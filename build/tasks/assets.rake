require "coffee-script"
require "less"
require "./bin/app_base"

def compiled_asset_dir
  File.expand_path "../../../public/assets", __FILE__
end

def compile_asset name
  asset = AppBase.settings.sprockets[name]
  outfile = Pathname.new(compiled_asset_dir).join asset.digest_path

  FileUtils.mkdir_p outfile.dirname

  asset.write_to outfile
  asset.write_to "#{outfile}.gz"
end

namespace :assets do
  desc "Compile assets"
  task :precompile => [:clean, :compile_js, :compile_css]

  desc "Remove compiled assets"
  task :clean do
    FileUtils.rm_rf compiled_asset_dir
  end

  desc "Compile javascript assets"
  task :compile_js do
    compile_asset "application.js"
    puts "Successfully compiled js assets"
  end

  desc "Compile css assets"
  task :compile_css do
    compile_asset "application.css"
    puts "Successfully compiled css assets"
  end
end
