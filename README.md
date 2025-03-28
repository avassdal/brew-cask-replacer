# Brew Cask Replacer (Modern Version)

A tool to replace manually installed applications in `/Applications` with Homebrew Cask versions, with enhanced features for safety and usability.

## Features

- **Automatic App Detection**: Scans `/Applications` and finds matching Homebrew casks
- **Backup & Restore**: Creates backups of applications before replacing them
- **Improved App Matching**: Intelligent matching of app names to Homebrew cask names
- **Interactive Mode**: Confirms each replacement before making changes
- **Dry Run Mode**: Shows what would happen without making changes
- **Progress Tracking**: Shows progress during operations
- **Detailed Logging**: Logs all operations with error handling

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/brew-cask-replacer.git
   cd brew-cask-replacer
   ```

2. Make the executable file executable:
   ```
   chmod +x bin/brew-cask-replacer
   ```

3. Optional: Create a symlink to make it available system-wide:
   ```
   sudo ln -s "$(pwd)/bin/brew-cask-replacer" /usr/local/bin/brew-cask-replacer
   ```

## Package Installation

For easier installation, you can download and install the macOS package (.pkg) from the [GitHub Releases page](https://github.com/avassdal/brew-cask-replacer/releases).

1. Download the latest `.pkg` file from the Releases page
2. Double-click the package file to launch the installer
3. Follow the installation prompts
4. The tool will be installed in `/usr/local/bin/brew-cask-replacer`

Alternatively, you can download the DMG, which contains the package installer and documentation.

## Usage

Basic usage (replace all apps):
```
./bin/brew-cask-replacer
```

### Command Line Options

- `--dry-run` or `-d`: Show what would happen without making changes
- `--interactive` or `-i`: Confirm each replacement
- `--backup-only` or `-b`: Create backups without replacing apps
- `--revert APP`: Restore a specific app from backup
- `--revert-all`: Restore all backed-up apps
- `--list-backups`: Show all available backups
- `--exclude-file FILE` or `-e FILE`: Specify a file containing apps to exclude
- `--verbose` or `-v`: Enable verbose output
- `--help` or `-h`: Show help message

### Examples

Create backups without replacing apps:
```
./bin/brew-cask-replacer --backup-only
```

Dry run to see what would happen:
```
./bin/brew-cask-replacer --dry-run
```

Interactive mode:
```
./bin/brew-cask-replacer --interactive
```

Restore a specific app from backup:
```
./bin/brew-cask-replacer --revert "Google Chrome"
```

## Configuration

You can create a configuration file in YAML format to customize the behavior of the tool. By default, the tool will look for a configuration file at `~/.brew-cask-replacer/config.yml`.

Example configuration:
```yaml
# Applications to exclude from replacement
exclude:
  - firefox
  - 'Google Chrome'
  - '/^microsoft.*/'  # Regex pattern for all Microsoft apps

# Backup directory where app backups will be stored
backup_dir: ~/.brew-cask-replacer/backups

# Log file path
log_file: ~/.brew-cask-replacer/logs/brew-cask-replacer.log

# Default behavior
interactive: false
dry_run: false
verbose: false
```

## Logs and Backups

- Logs are stored in `~/.brew-cask-replacer/logs/brew-cask-replacer.log`
- Backups are stored in `~/.brew-cask-replacer/backups/`

## License

Copyright 2021 Lorenz Kitzmann
Modified work Copyright 2025 Aleksander Vassdal


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
