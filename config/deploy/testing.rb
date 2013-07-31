set :snoozenode_deb_url, "https://ci.inria.fr/snooze-software/job/testing-snoozenode/ws/distributions/deb-package/snoozenode_1.1.0-0_all.deb"
set :snoozeclient_deb_url, "https://ci.inria.fr/snooze-software/job/testing-snoozeclient/ws/distributions/deb-package/snoozeclient_1.1.0-0_all.deb"
set :snooze_capistrano_branch, "testing"
#set :snoozenode_deb_url, "http://public.nancy.grid5000.fr/~msimonin/snooze/testing/snoozenode_1.1.0-0_all.deb"
#set :snoozeclient_deb_url, "http://public.nancy.grid5000.fr/~msimonin/snooze/testing/snoozeclient_1.1.0-0_all.deb"


load 'config/deploy/xp5k/xp5k_testing.rb'
# load recipes
# don't forget to change stage to install specific version
recipes = ["rabbitmq","nfs", "snooze"]

recipes.each do |recipe|
  load "#{recipes_path}/#{recipe}/recipe.rb"
end

desc 'Automatic deployment'
task :automatic do
  puts "Welcome to Snooze deployment".bold.blue
end

after "automatic", "xp5k", "rabbitmq", "nfs", "snooze"
