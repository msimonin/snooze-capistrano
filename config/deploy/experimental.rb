# used to test version under developpement.

set :branch, "experimental"
set :version, "2"

set :snoozenode_deb_url, "http://public.rennes.grid5000.fr/~msimonin/snooze/experimental/snoozenode_exp.deb"
#set :snoozenode_deb_url, "https://ci.inria.fr/snooze-software/job/maint-2.1.0-snoozenode/ws/distributions/deb-package/snoozenode_2.1.3-0_all.deb"

set :snoozeclient_deb_url, "http://public.rennes.grid5000.fr/~msimonin/snooze/experimental/snoozeclient_exp.deb"
set :snoozeimages_deb_url, "http://public.rennes.grid5000.fr/~msimonin/snooze/experimental/snoozeimages_exp.deb"
#set :snoozeimages_deb_url, "https://ci.inria.fr/snooze-software/view/maint/job/maint-2.1.0-snoozeimages/ws/distributions/deb-package/snoozeimages_2.1.3-0_all.deb"

set :snoozeec2_deb_url, "http://public.rennes.grid5000.fr/~msimonin/snooze/experimental/snoozeec2_exp.deb"
#set :snoozeec2_deb_url, "https://ci.inria.fr/snooze-software/view/maint/job/maint-2.1.0-snoozeec2/ws/distributions/deb-package/snoozeec2_2.1.3-0_all.deb"

set :kadeploy3_common_deb_url, "https://gforge.inria.fr/frs/download.php/33023/kadeploy-common-3.1.7.3.deb"
set :kadeploy3_client_deb_url, "https://gforge.inria.fr/frs/download.php/33022/kadeploy-client-3.1.7.3.deb"

$plugins=[]
$plugins << {
  :url => "http://public.rennes.grid5000.fr/~msimonin/snooze/experimental/btrPlaceConsolidation.jar",
  :destination => "/usr/share/snoozenode/plugins/btrPlaceConsolidation.jar"
}

load 'config/deploy/xp5k/xp5k_snooze.rb'

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

after "automatic", "xp5k", "rabbitmq","cassandra", "snooze",  "nfs", "snooze:cluster:start", "snooze_webinterface"
