# Used to deploy snooze v2.1.0
set :branch, "v2.1.0"
set :snoozenode_deb_url, "https://github.com/snoozesoftware/snoozenode/releases/download/snoozenode-2.1.0/snoozenode_2.1.0-0_all.deb"
set :snoozeclient_deb_url, "https://ci.inria.fr/snooze-software/job/testing-snoozeclient/ws/distributions/deb-package/snoozeclient_2.0.0-0_all.deb"
set :snoozeimages_deb_url, "https://github.com/snoozesoftware/snoozeimages/releases/download/snoozeimages-2.1.0/snoozeimages_2.1.0-0_all.deb"
set :snoozeec2_deb_url, "https://github.com/snoozesoftware/snoozeec2/releases/download/snoozeec2-2.1.0/snoozeec2_2.1.0-0_all.deb"


set :kadeploy3_common_deb_url, "https://gforge.inria.fr/frs/download.php/32874/kadeploy-common-3.1.7.2.deb"
set :kadeploy3_client_deb_url, "https://gforge.inria.fr/frs/download.php/32873/kadeploy-client-3.1.7.2.deb"

$plugins=[]
=begin
$plugins << {
  :url => "https://ci.inria.fr/snooze-software/job/snooze-plugins/ws/random-scheduling/target/random-scheduling-2.0-SNAPSHOT.jar",
  :destination => "/usr/share/snoozenode/plugins/groupManagerScheduler"
}
=end

load 'config/deploy/xp5k/xp5k_2.x.rb'

# load recipes
# don't forget to change stage to install specific version
recipes = ["rabbitmq","cassandra", "nfs", "snooze", "snooze_webinterface"]

recipes.each do |recipe|
  load "#{recipes_path}/#{recipe}/recipe.rb"
end

desc 'Automatic deployment'
task :automatic do
 puts "Welcome to Snooze deployment".bold.blue
end

after "automatic", "xp5k", "rabbitmq","cassandra", "snooze", "nfs","snooze:cluster:start", "snooze_webinterface"
