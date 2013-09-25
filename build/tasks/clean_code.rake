namespace :code do

  desc 'Runs all code quality checks'
  task :all => [:trailing_spaces, :shoulds, :debugger, :console_log]

  desc 'check for trailing spaces'
  task :trailing_spaces do
   grep_for_trailing_space %w{spec features lib bin assets}
  end

  desc %(check for 'it "should ..."' style specs)
  task :shoulds do
    grep_for_shoulds %w{spec}
  end

  desc 'check for debugger statements'
  task :debugger do
   grep_for_debugger %w{lib bin spec}
  end

  desc 'check for console.log'
  task :console_log do
   grep_for_console_log %w{assets/js/controllers assets/js/directives assets/js/map }
  end

  def grep_for_trailing_space *file_patterns
    grep '^.*[[:space:]]+$', file_patterns, 'trailing spaces', ['*.yml', '*.csv']
  end

  def grep_for_shoulds *file_patterns
    grep '^[[:space:]]*it "should.*$',
         file_patterns,
         'it block description starting with should'
  end

  def grep_for_debugger *file_patterns
    grep 'debugger',
         file_patterns,
         'debugger statement found',
         ['spec_helper.rb']
  end

  def grep_for_console_log *file_patterns
    grep 'console.log',
         file_patterns,
         'console.log statement found'
  end

  def grep regex, file_patterns, error_message, exclude_patterns=[], perl_regex=false
    files_found = ""
    command = "grep -r -n --binary-files=without-match '#{regex}' #{file_patterns.join(' ')}"
    exclude_patterns.each do |exclude_pattern|
      command << " --exclude '#{exclude_pattern}'"
    end
    command << (perl_regex ? ' -P' : ' -E')
    files_found << `#{command}`
    abort("#{error_message} found:\n#{files_found}") unless files_found.empty?
  end
end
