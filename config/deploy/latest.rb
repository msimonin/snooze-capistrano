# Used to deploy snooze the latest release
set :branch, "latest"
# config file version
set :version, 2

set :snoozenode_deb_url, "http://snooze.inria.fr/downloads/debian/latest/snoozenode.deb"
set :snoozeclient_deb_url, "http://snooze.inria.fr/downloads/debian/latest/snoozeclient.deb"
set :snoozeimages_deb_url, "http://snooze.inria.fr/downloads/debian/latest/snoozeimages.deb"
set :snoozeec2_deb_url, "http://snooze.inria.fr/downloads/debian/latest/snoozeec2.deb"



set :kadeploy3_common_deb_url, "https://gforge.inria.fr/frs/download.php/33023/kadeploy-common-3.1.7.3.deb"
set :kadeploy3_client_deb_url, "https://gforge.inria.fr/frs/download.php/33022/kadeploy-client-3.1.7.3.deb"

load 'config/deploy/xp5k/xp5k_snooze.rb'

# load recipes
recipes = ["rabbitmq","cassandra", "nfs", "snooze", "snooze_webinterface"]

recipes.each do |recipe|
  load "#{recipes_path}/#{recipe}/recipe.rb"
end

desc 'Automatic deployment'
task :automatic do
 puts "Welcome to Snooze deployment".bold.blue
end

after "automatic", "xp5k", "rabbitmq","cassandra", "snooze", "nfs","snooze:cluster:start", "snooze_webinterface"
