# Component Version Scanner

## Overview

This bash script scans a Git repository and generates a YAML file with versions of components found in their respective `changelog.md` files.

## Features

- Clone a specific repository branch
- Extract all published versions for each component
- Generate a structured YAML file
- Supports custom repository URL and branch
- Automatically cleans up temporary files

## Prerequisites

- Git
- Bash shell
- Basic command-line knowledge

## Usage

### Basic Usage

```bash
./scan_versions.sh
```
This will:
- Clone the default repository (6G-SANDBOX/6G-Library)
- Use the main branch
- Generate `component_versions.yaml` in the script's directory

### Advanced Usage

```bash
# Specify a different branch
./scan_versions.sh -r develop

# Specify a different repository and branch
./scan_versions.sh -u https://github.com/otherUser/otherRepository -r feature-branch
```

### Parameters

- `-r`: Specify the repository branch (default: main)
- `-u`: Specify the repository URL (default: https://github.com/6G-SANDBOX/6G-Library)

## Output Format

The generated YAML file will look like:

```yaml
components:
  repository_url: https://github.com/example/repo
  branch: main
  components:
    component1:
      versions:
        - 1.2.3
        - 1.2.2
    component2:
      versions:
        - 0.9.1
        - 0.9.0
```

## Installation

1. Download the script
2. Make it executable:
   ```bash
   chmod +x scan_versions.sh
   ```

## Requirements

- Bash 4.0+
- Git 2.0+

## Troubleshooting

- Ensure you have internet connection
- Check repository URL and branch name
- Verify changelog.md format in each component directory

## Contributing

Contributions are welcome! Please submit a pull request or open an issue.
