set :snoozenode_deb_url, "https://ci.inria.fr/snooze-software/job/snoozenode-maint1.0.0/ws/distributions/deb-package/snoozenode_1.0.0-0_all.deb"
set :snoozeclient_deb_url, "https://ci.inria.fr/snooze-software/job/snoozeclient-maint1.0.0/ws/distributions/deb-package/snoozeclient_1.0.0-0_all.deb"


load 'config/deploy/xp5k/xp5k_maint1.0.0.rb'
# load recipes
# don't forget to change stage to install specific version
recipes = ["nfs", "snooze"]

recipes.each do |recipe|
  load "#{recipes_path}/#{recipe}/recipe.rb"
end

desc 'Automatic deployment'
task :automatic do
  puts "Welcome to Snooze deployment".bold.blue
end

after "automatic", "xp5k", "rabbitmq", "nfs", "snooze"


