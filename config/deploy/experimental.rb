set :snoozenode_deb_url, "http://public.rennes.grid5000.fr/~msimonin/snooze/experimental/snoozenode_exp.deb"
set :snoozeclient_deb_url, "http://public.rennes.grid5000.fr/~msimonin/snooze/experimental/snoozeclient_exp.deb"
set :snooze_capistrano_branch, "exp"

load 'config/deploy/xp5k/xp5k_experimental.rb'

# load recipes
# don't forget to change stage to install specific version
recipes = ["rabbitmq", "cassandra", "nfs", "snooze"]

recipes.each do |recipe|
  load "#{recipes_path}/#{recipe}/recipe.rb"
end

desc 'Automatic deployment'
task :automatic do
 puts "Welcome to Snooze deployment".bold.blue
end

after "automatic", "xp5k", "rabbitmq", "cassandra", "nfs", "snooze"
