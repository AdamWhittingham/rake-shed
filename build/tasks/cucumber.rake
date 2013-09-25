def common_opts task
  task.fork = true
  task.bundler = true
  task.cucumber_opts = "--profile rake"
end

begin
  require 'cucumber/rake/task'
  task :cucumber => [:'cucumber:api', :'cucumber:pages', :'cucumber:e2e']

  namespace :cucumber do
    Cucumber::Rake::Task.new('api') do |t|
      common_opts t
      t.profile = 'api'
    end

    Cucumber::Rake::Task.new('pages') do |t|
      common_opts t
      t.profile = 'pages'
    end

    Cucumber::Rake::Task.new('e2e') do |t|
      common_opts t
      t.profile = 'e2e'
    end

    Cucumber::Rake::Task.new('wip') do |t|
      common_opts t
      t.profile = 'wip'
    end
  end
rescue LoadError
  $stderr.puts 'Warning: Cucumber not available.'
end
