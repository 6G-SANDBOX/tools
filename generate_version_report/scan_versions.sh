#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 [-r branch] [-u url]"
    echo "  -r: Repository branch (default: main)"
    echo "  -u: Repository URL (default: https://github.com/6G-SANDBOX/6G-Library)"
    exit 1
}

# Cleanup function to remove temporary directory
cleanup() {
    rm -rf "$TEMP_DIR"
}

# Set up trap for cleanup in case of error
trap cleanup EXIT

# Default values
REPO_URL="https://github.com/6G-SANDBOX/6G-Library"
BRANCH="main"
OUTPUT_YAML="component_versions.yaml"

# Parse command line arguments
while getopts ":r:u:" opt; do
    case ${opt} in
        r )
            BRANCH=$OPTARG
            ;;
        u )
            REPO_URL=$OPTARG
            ;;
        \? )
            usage
            ;;
    esac
done

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create temporary directory for the repository
TEMP_DIR=$(mktemp -d)

# Change to temporary directory
cd "$TEMP_DIR" || exit 1

# Clone only the specified branch with minimal depth
git clone --depth 1 -b "$BRANCH" "$REPO_URL"

# Repository name (extracted from URL)
REPO_NAME=$(basename "$REPO_URL" .git)

# Change to repository directory
cd "$REPO_NAME" || exit 1

# Full path of the output YAML file
OUTPUT_PATH="$SCRIPT_DIR/$OUTPUT_YAML"

# Start the YAML file
echo "components:" > "$OUTPUT_PATH"
echo "  repository_url: $REPO_URL" >> "$OUTPUT_PATH"
echo "  branch: $BRANCH" >> "$OUTPUT_PATH"
echo "  components:" >> "$OUTPUT_PATH"

# Iterate over each directory
for dir in */; do
    # Remove trailing slash from directory name
    component=$(basename "$dir")
    
    # Check if changelog.md exists
    if [ -f "${dir}changelog.md" ]; then
        # Extract all versions from the changelog
        versions=$(grep -E "^## " "${dir}changelog.md" | sed -E 's/^## *([^ ]+).*/\1/')
        
        # Check if versions were found
        if [ -n "$versions" ]; then
            echo "    $component:" >> "$OUTPUT_PATH"
            echo "      versions:" >> "$OUTPUT_PATH"
            
            # Convert versions to YAML list format
            while IFS= read -r version; do
                echo "        - $version" >> "$OUTPUT_PATH"
            done <<< "$versions"
        fi
    fi
done

echo "Scan completed. $OUTPUT_YAML file generated in $SCRIPT_DIR"
