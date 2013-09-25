require "rake/clean"

task :default => [:pick_out_your_build_tools_and_order_here, 
                  :"code:all", :clean, :"assets:clean", :"db:migrate", :spec, :"coverage:check_specs", :jasmine, :cucumber, :ok]
task :ci => [:default, :"cucumber:e2e", :"coverage:check_cucumber", :ok]

task :ok do
  red    = "\e[31m"
  yellow = "\e[33m"
  green  = "\e[32m"
  blue   = "\e[34m"
  purple = "\e[35m"
  bold   = "\e[1m"
  normal = "\e[0m"
  puts "", "#{bold}#{red}*#{yellow}*#{green}*#{blue}*#{purple}*#{green} ALL TESTS PASSED #{purple}*#{blue}*#{green}*#{yellow}*#{red}*#{normal}"
end
