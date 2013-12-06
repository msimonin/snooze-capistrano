# used to test the master branch
set :branch, "master"
set :snoozenode_deb_url, "https://ci.inria.fr/snooze-software/job/master-snoozenode/ws/distributions/deb-package/snoozenode_2.2.0-0_all.deb"
set :snoozeclient_deb_url, "https://ci.inria.fr/snooze-software/job/master-snoozeclient/ws/distributions/deb-package/snoozeclient_2.1.0-0_all.deb"
set :snoozeimages_deb_url, "https://ci.inria.fr/snooze-software/job/snoozeimages/ws/distributions/deb-package/snoozeimages_2.2.0-0_all.deb"
set :snoozeec2_deb_url, "https://ci.inria.fr/snooze-software/job/snoozeec2/ws/distributions/deb-package/snoozeec2_2.2.0-0_all.deb"

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
recipes = ["rabbitmq","cassandra", "nfs", "snooze"]

recipes.each do |recipe|
  load "#{recipes_path}/#{recipe}/recipe.rb"
end

desc 'Automatic deployment'
task :automatic do
 puts "Welcome to Snooze deployment".bold.blue
end

after "automatic", "xp5k", "rabbitmq","cassandra", "snooze", "nfs"
