#!/usr/bin/env ruby
# Backup manager for Brew Cask Replacer

require 'fileutils'
require 'json'
require 'time'

class BackupManager
  def initialize(backup_dir, error_handler)
    @backup_dir = backup_dir
    @error_handler = error_handler
    
    # Create backup directory if it doesn't exist
    FileUtils.mkdir_p(@backup_dir)
    @error_handler.log_info("Backup directory: #{@backup_dir}")
  end
  
  # Create a backup of an app
  def backup_app(app_path, app_name)
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    backup_app_dir = File.join(@backup_dir, "#{app_name}_#{timestamp}")
    
    begin
      # Create backup directory
      FileUtils.mkdir_p(backup_app_dir)
      
      # Save metadata
      metadata = {
        'original_path' => app_path,
        'app_name' => app_name,
        'backup_time' => Time.now.iso8601,
        'backup_path' => backup_app_dir
      }
      
      File.write(File.join(backup_app_dir, 'metadata.json'), JSON.pretty_generate(metadata))
      
      # Copy app to backup directory
      @error_handler.log_info("Backing up #{app_name} to #{backup_app_dir}")
      FileUtils.cp_r(app_path, backup_app_dir)
      
      @error_handler.log_info("Successfully backed up #{app_name}")
      return true
    rescue => e
      @error_handler.log_error("Failed to backup #{app_name}: #{e.message}")
      return false
    end
  end
  
  # Restore an app from backup
  def revert_app(app_name)
    backups = find_backups(app_name)
    
    if backups.empty?
      @error_handler.log_error("No backups found for #{app_name}")
      puts "No backups found for #{app_name}"
      return false
    end
    
    # Sort by backup time (newest first)
    backups.sort_by! { |b| Time.parse(b['backup_time']) }.reverse!
    
    # Use the most recent backup
    backup = backups.first
    
    puts "Restoring #{app_name} from backup created at #{backup['backup_time']}"
    
    begin
      # Check if the app is currently installed by Homebrew
      app_path = backup['original_path']
      
      # Remove current app if it exists
      if File.exist?(app_path)
        puts "Removing current version of #{app_name}..."
        FileUtils.rm_rf(app_path)
      end
      
      # Restore from backup
      puts "Restoring #{app_name} from backup..."
      backup_app_path = Dir.glob(File.join(backup['backup_path'], "*.app")).first
      
      if backup_app_path.nil?
        @error_handler.log_error("Could not find app in backup directory")
        puts "Could not find app in backup directory"
        return false
      end
      
      FileUtils.cp_r(backup_app_path, app_path)
      puts "Successfully restored #{app_name}"
      return true
    rescue => e
      @error_handler.log_error("Failed to restore #{app_name}: #{e.message}")
      puts "Failed to restore #{app_name}: #{e.message}"
      return false
    end
  end
  
  # Restore all backed-up apps
  def revert_all
    # Get all backup directories
    backup_dirs = Dir.glob(File.join(@backup_dir, "*")).select { |f| File.directory?(f) }
    
    if backup_dirs.empty?
      puts "No backups found"
      return
    end
    
    # Group by app name
    backups_by_app = {}
    
    backup_dirs.each do |dir|
      metadata_file = File.join(dir, 'metadata.json')
      next unless File.exist?(metadata_file)
      
      begin
        metadata = JSON.parse(File.read(metadata_file))
        app_name = metadata['app_name']
        backups_by_app[app_name] ||= []
        backups_by_app[app_name] << metadata
      rescue JSON::ParserError
        @error_handler.log_error("Failed to parse metadata for #{dir}")
      end
    end
    
    # Restore the most recent backup for each app
    success_count = 0
    total_count = backups_by_app.size
    
    backups_by_app.each do |app_name, backups|
      # Sort by backup time (newest first)
      backups.sort_by! { |b| Time.parse(b['backup_time']) }.reverse!
      
      if revert_app(app_name)
        success_count += 1
      end
    end
    
    puts "Restored #{success_count} of #{total_count} apps"
  end
  
  # List all available backups
  def list_backups
    # Get all backup directories
    backup_dirs = Dir.glob(File.join(@backup_dir, "*")).select { |f| File.directory?(f) }
    
    if backup_dirs.empty?
      puts "No backups found"
      return
    end
    
    # Group by app name
    backups_by_app = {}
    
    backup_dirs.each do |dir|
      metadata_file = File.join(dir, 'metadata.json')
      next unless File.exist?(metadata_file)
      
      begin
        metadata = JSON.parse(File.read(metadata_file))
        app_name = metadata['app_name']
        backups_by_app[app_name] ||= []
        backups_by_app[app_name] << metadata
      rescue JSON::ParserError
        @error_handler.log_error("Failed to parse metadata for #{dir}")
      end
    end
    
    # Print backups
    puts "Available backups:"
    backups_by_app.each do |app_name, backups|
      # Sort by backup time (newest first)
      backups.sort_by! { |b| Time.parse(b['backup_time']) }.reverse!
      
      puts "\n#{app_name}:"
      backups.each do |backup|
        puts "  - #{backup['backup_time']}"
      end
    end
  end
  
  private
  
  # Find all backups for an app
  def find_backups(app_name)
    backups = []
    
    # Get all backup directories
    backup_dirs = Dir.glob(File.join(@backup_dir, "#{app_name}_*")).select { |f| File.directory?(f) }
    
    backup_dirs.each do |dir|
      metadata_file = File.join(dir, 'metadata.json')
      next unless File.exist?(metadata_file)
      
      begin
        metadata = JSON.parse(File.read(metadata_file))
        backups << metadata if metadata['app_name'] == app_name
      rescue JSON::ParserError
        @error_handler.log_error("Failed to parse metadata for #{dir}")
      end
    end
    
    backups
  end
end
