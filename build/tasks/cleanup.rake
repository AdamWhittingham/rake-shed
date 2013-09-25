namespace :logs do
  task :cleanup do
    FileUtils.rm_rf('log', 'tmp')
  end
end
