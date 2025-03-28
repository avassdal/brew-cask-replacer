#!/usr/bin/env ruby
# Homebrew interface for Brew Cask Replacer

class HomebrewInterface
  def initialize(error_handler)
    @error_handler = error_handler
  end
  
  # Check if Homebrew is installed
  def installed?
    system("which brew > /dev/null 2>&1")
  end
  
  # Install a cask
  def install_cask(cask_name)
    @error_handler.log_info("Installing #{cask_name} using Homebrew...")
    
    # Get Homebrew options from environment
    homebrew_opts = ENV['HOMEBREW_CASK_OPTS'] || ''
    
    # Run the installation command
    command = "brew install --cask #{cask_name} #{homebrew_opts}".strip
    @error_handler.log_debug("Running command: #{command}")
    
    # Execute the command
    result = system(command)
    
    if result
      @error_handler.log_info("Successfully installed #{cask_name}")
    else
      @error_handler.log_error("Failed to install #{cask_name}")
    end
    
    result
  end
  
  # Uninstall a cask
  def uninstall_cask(cask_name)
    @error_handler.log_info("Uninstalling #{cask_name}...")
    
    # Run the uninstallation command
    command = "brew uninstall --cask #{cask_name}"
    @error_handler.log_debug("Running command: #{command}")
    
    # Execute the command
    result = system(command)
    
    if result
      @error_handler.log_info("Successfully uninstalled #{cask_name}")
    else
      @error_handler.log_error("Failed to uninstall #{cask_name}")
    end
    
    result
  end
  
  # Check if a cask is installed
  def cask_installed?(cask_name)
    command = "brew list --cask #{cask_name} &>/dev/null"
    system(command)
  end
  
  # Get Homebrew version
  def get_version
    `brew --version`.strip
  end
  
  # Check if cask is available
  def cask_available?(cask_name)
    command = "brew info --cask #{cask_name} &>/dev/null"
    system(command)
  end
end
