desc "Display the latest version (from history.rdoc)"
task :version do
  puts "Latest version is #{latest_version}"
end

namespace :version do
  namespace :increment do
    desc "Increment the major version in history.rdoc (eg 1.2.3 => 2.0.0)"
    task :major do
      new_version = latest_version
      new_version[0] += 1
      new_version[1,2] = 0, 0
      update_to new_version
    end

    desc "Increment the minor version in history.rdoc (eg 1.2.3 => 1.3.0)"
    task :minor do
      new_version = latest_version
      new_version[1] += 1
      new_version[2] = 0
      update_to new_version
    end

    desc "Increment the patch version in history.rdoc (eg 1.2.3 => 1.2.4)"
    task :patch do
      new_version = latest_version
      new_version[2] += 1
      update_to new_version
    end
  end
end

private

def current_history
  File.read "history.rdoc"
end

def latest_version
  @latest_version ||= current_history[/== ([\d\.]*)/, 1].split(".").map(&:to_i)
  def @latest_version.to_s
    join "."
  end
  @latest_version
end

def update_to version
  add_history_header version
  commit version
  tag version
  branch = `git symbolic-ref HEAD`[%r{.*/(.*)}, 1]
  puts "To push the new tag, use 'git push origin #{branch} --tags'"
end

def add_history_header version
  puts "in add_history_header"
  history = current_history
  File.open "history.rdoc", "w" do |f|
    f.puts "== #{version} (#{Time.now.strftime "%d %B %Y"})"
    f.puts
    f.print history
  end
  puts "Added version to history.rdoc"
end

def commit version
  `git commit history.rdoc -m'increment version to #{version}'`
  puts "Committed change"
end

def tag version
  `git tag #{version}`
  puts "Tagged with #{version}"
end
