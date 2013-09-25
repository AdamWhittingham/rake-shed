if File.exists? 'config/shared/database.yml'
  require "dm-migrations"
  require "models"

  namespace :db do
    desc "Auto-upgrade the database schema"
    task :migrate do
      DataMapper.auto_upgrade!
    end

    task :reset do
      DataMapper.auto_migrate!
    end
  end
else
  $stderr.puts 'Warning: Database task not loaded: config/database.yml not available.'
end
