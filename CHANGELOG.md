# Changelog

All notable changes to the Brew Cask Replacer project will be documented in this file.

## [1.1.0] - 2025-03-28

### Complete Modernization and Enhancement

#### Project Structure
- Reorganized project into a modular structure
- Created dedicated directories for binaries, libraries, and configuration
- Improved code organization and separation of concerns

#### New Features
- **Command Line Interface**
  - Added support for multiple command line options
  - Implemented --help flag for usage information
  - Added dry-run mode for testing without making changes
  
- **Backup System**
  - Implemented automatic backup before app replacement
  - Added metadata tracking for backups
  - Created restore functionality for individual apps or all apps
  - Added backup listing command
  
- **Improved App Matching**
  - Enhanced algorithm for app name matching
  - Added fuzzy matching using Levenshtein distance
  - Created mappings for common app name variations
  - Improved handling of special characters and version numbers
  
- **Progress Tracking**
  - Added visual progress bar
  - Implemented counters for processed/installed/failed apps
  - Added operation timing information
  
- **Configuration Management**
  - Added YAML-based configuration system
  - Implemented file-based app exclusion lists
  - Created default configuration with customizable options

#### Technical Improvements
- **Error Handling**
  - Implemented comprehensive error detection and reporting
  - Added detailed logging system with configurable verbosity
  - Created recovery mechanisms for common failure scenarios
  
- **Homebrew Integration**
  - Updated for modern Homebrew commands and output formats
  - Added verification of Homebrew installation
  - Improved cask installation process

#### Documentation
- Completely rewritten README with detailed usage instructions
- Added examples for common usage scenarios
- Created configuration reference
- Documented backup and restore functionality

## [0.1.0] - 2021

### Initial Release by Lorenz Kitzmann
- Basic functionality to replace manually installed apps with Homebrew cask versions
- Simple script with minimal error handling
- Original implementation
