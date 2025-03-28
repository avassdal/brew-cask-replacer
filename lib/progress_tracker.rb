#!/usr/bin/env ruby
# Progress tracker for Brew Cask Replacer

class ProgressTracker
  attr_accessor :total

  def initialize
    @total = 0
    @current = 0
    @start_time = nil
    @task_name = nil
  end

  # Start tracking progress
  def start(task_name)
    @start_time = Time.now
    @task_name = task_name
    @current = 0
    
    puts "#{@task_name}..."
    print_progress_bar if @total > 0
  end

  # Increment progress
  def increment(amount = 1)
    @current += amount
    print_progress_bar if @total > 0
  end

  # Finish progress tracking
  def finish
    elapsed = Time.now - @start_time
    print_progress_bar(force_complete: true) if @total > 0
    puts "\nCompleted in #{elapsed.round(2)} seconds"
  end

  private

  # Print a progress bar
  def print_progress_bar(force_complete: false)
    percentage = force_complete ? 100 : [(@current.to_f / @total * 100).round, 100].min
    bar_length = 30
    completed_length = (bar_length * percentage / 100).round
    remaining_length = bar_length - completed_length
    
    bar = "["
    bar += "=" * completed_length
    bar += ">" unless force_complete || completed_length == bar_length
    bar += " " * (remaining_length - (force_complete || completed_length == bar_length ? 0 : 1))
    bar += "]"
    
    print "\r#{@task_name}: #{bar} #{percentage}% (#{@current}/#{@total})"
  end
end
