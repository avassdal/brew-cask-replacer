#!/usr/bin/env ruby
# Error handler for Brew Cask Replacer

require 'logger'

class ErrorHandler
  attr_reader :logger

  def initialize(log_file, verbose = false)
    @verbose = verbose
    
    # Setup logger
    @logger = Logger.new(log_file)
    @logger.level = verbose ? Logger::DEBUG : Logger::INFO
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} [#{severity}] #{msg}\n"
    end
    
    log_info("Brew Cask Replacer started")
  end

  def log_error(message)
    puts "\e[31mERROR: #{message}\e[0m" if @verbose
    @logger.error(message)
  end

  def log_warning(message)
    puts "\e[33mWARNING: #{message}\e[0m" if @verbose
    @logger.warn(message)
  end

  def log_info(message)
    puts message if @verbose
    @logger.info(message)
  end

  def log_debug(message)
    puts "DEBUG: #{message}" if @verbose
    @logger.debug(message)
  end

  def exit_with_error(message)
    log_error(message)
    puts "\e[31mERROR: #{message}\e[0m"
    exit(1)
  end
end
