#set :snoozenode_deb_url, "http://public.rennes.grid5000.fr/~msimonin/snooze/experimental/snoozenode_exp.deb"
#set :snoozeclient_deb_url, "http://public.rennes.grid5000.fr/~msimonin/snooze/experimental/snoozeclient_exp.deb"

set :snoozenode_deb_url, "https://ci.inria.fr/snooze-software/job/maint-2.0.0-snoozenode/ws/distributions/deb-package/snoozenode_2.0.0-0_all.deb" 
set :snoozeclient_deb_url, "https://ci.inria.fr/snooze-software/job/maint-2.0.0-snoozeclient/ws/distributions/deb-package/snoozeclient_2.0.0-0_all.deb"


set :kadeploy3_common_deb_url, "https://gforge.inria.fr/frs/download.php/32874/kadeploy-common-3.1.7.2.deb"
set :kadeploy3_client_deb_url, "https://gforge.inria.fr/frs/download.php/32873/kadeploy-client-3.1.7.2.deb"

$plugins=[]
$plugins << {
  :url => "https://ci.inria.fr/snooze-software/job/snooze-plugins/ws/random-scheduling/target/random-scheduling-2.0-SNAPSHOT.jar",
  :destination => "/usr/share/snoozenode/plugins/groupManagerScheduler"
}

load 'config/deploy/xp5k/xp5k_maint-2.0.0.rb'

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

after "automatic", "xp5k", "rabbitmq","cassandra", "nfs", "snooze", "snooze_webinterface"
