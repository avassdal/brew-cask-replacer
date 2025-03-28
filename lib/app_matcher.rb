#!/usr/bin/env ruby
# App matcher for Brew Cask Replacer

class AppMatcher
  # Common name variations and mappings
  NAME_MAPPINGS = {
    'google chrome' => 'google-chrome',
    'firefox' => 'firefox',
    'visual studio code' => 'visual-studio-code',
    'vscode' => 'visual-studio-code',
    'sublime text' => 'sublime-text',
    'iterm' => 'iterm2',
    'alfred' => 'alfred',
    'slack' => 'slack',
    'discord' => 'discord',
    'spotify' => 'spotify',
    'vlc' => 'vlc',
    'zoom' => 'zoom',
    'docker' => 'docker',
    'notion' => 'notion'
    # Add more mappings as needed
  }

  def initialize(exclude_list, error_handler)
    @exclude_list = exclude_list || []
    @error_handler = error_handler
  end

  # Find a matching Homebrew cask for an app
  def find_matching_cask(app_name)
    # Clean app name by removing version numbers and special characters
    clean_name = clean_app_name(app_name)
    
    # Check exclude list
    if is_excluded?(clean_name)
      @error_handler.log_info("Skipping excluded app: #{app_name}")
      return nil
    end
    
    # Try direct mapping first
    cask_name = check_direct_mapping(clean_name.downcase)
    return cask_name if cask_name
    
    # Search for cask
    cask_name = search_homebrew_cask(clean_name)
    
    if cask_name
      @error_handler.log_info("Found matching cask '#{cask_name}' for '#{app_name}'")
    else
      @error_handler.log_info("No matching cask found for '#{app_name}'")
    end
    
    cask_name
  end
  
  private
  
  # Clean app name by removing version numbers and special characters
  def clean_app_name(app_name)
    # Remove file extension
    name = app_name.sub(/.app\z/, '')
    
    # Remove version numbers
    name = name.sub(/ \d+(\.\d+)*\z/, '')
    
    # Remove parentheses and their contents
    name = name.gsub(/\s*\([^)]*\)/, '')
    
    # Clean up extra whitespace
    name = name.strip
    
    name
  end
  
  # Check if app is in the exclude list
  def is_excluded?(app_name)
    @exclude_list.any? do |exclude_pattern|
      # Support both exact matches and regex patterns
      if exclude_pattern.start_with?('/') && exclude_pattern.end_with?('/')
        # Regex pattern
        pattern = exclude_pattern[1..-2]
        Regexp.new(pattern, Regexp::IGNORECASE).match?(app_name)
      else
        # Exact match (case insensitive)
        app_name.downcase == exclude_pattern.downcase
      end
    end
  end
  
  # Check direct mapping
  def check_direct_mapping(app_name)
    NAME_MAPPINGS[app_name.downcase]
  end
  
  # Search for Homebrew cask
  def search_homebrew_cask(app_name)
    # Run brew search and parse output
    search_result = `brew search --cask #{app_name.shellescape} 2>/dev/null`
    
    # Check for exact match in output
    if search_result.include?("==> Casks")
      # Modern brew output format
      casks = search_result.split("==> Casks").last.strip.split("\n")
      
      # Try to find an exact match first
      exact_match = casks.find do |cask| 
        cask.downcase == app_name.downcase || 
        cask.downcase.gsub('-', ' ') == app_name.downcase
      end
      
      return exact_match if exact_match
      
      # If no exact match, return the first result if there's only one
      return casks.first if casks.size == 1
      
      # For multiple results, calculate similarity scores
      scores = casks.map do |cask|
        score = calculate_similarity(cask, app_name)
        [cask, score]
      end
      
      # Sort by score (highest first)
      scores.sort_by! { |_, score| -score }
      
      # Return the cask with the highest score if it's above threshold
      best_match, best_score = scores.first
      return best_match if best_score > 0.6
    end
    
    nil
  end
  
  # Calculate similarity between two strings
  def calculate_similarity(str1, str2)
    # Convert to lowercase and remove dashes for comparison
    a = str1.downcase.gsub('-', ' ')
    b = str2.downcase
    
    # Calculate Levenshtein distance
    distance = levenshtein_distance(a, b)
    max_length = [a.length, b.length].max
    
    # Convert to similarity score (1 is exact match, 0 is completely different)
    1 - (distance.to_f / max_length)
  end
  
  # Levenshtein distance calculation
  def levenshtein_distance(str1, str2)
    # Create matrix
    d = Array.new(str1.length + 1) { Array.new(str2.length + 1) }
    
    # Initialize first row and column
    (0..str1.length).each { |i| d[i][0] = i }
    (0..str2.length).each { |j| d[0][j] = j }
    
    # Fill the matrix
    (1..str1.length).each do |i|
      (1..str2.length).each do |j|
        cost = str1[i-1] == str2[j-1] ? 0 : 1
        d[i][j] = [
          d[i-1][j] + 1,           # deletion
          d[i][j-1] + 1,           # insertion
          d[i-1][j-1] + cost       # substitution
        ].min
      end
    end
    
    d[str1.length][str2.length]
  end
end
