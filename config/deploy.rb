require 'capistrano/ext/multistage'

set :stages, %w(master maint1.0.0 testing)
set :default_stage, "master"

set :g5k_user, "msimonin"
set :gateway, "#{g5k_user}@access.grid5000.fr"
set :snooze_capistrano_repo_url, "https://github.com/msimonin/snooze-capistrano.git"
set :snooze_puppet_repo_url, "https://github.com/msimonin/snooze-puppet.git"
set :snooze_experiments_repo_url, "https://github.com/msimonin/snooze-grid5000-multisite.git"
ssh_options[:keys]= [File.join(ENV["HOME"], ".ssh_cap", "id_rsa_cap")]
set :ssh_public,  File.join(ENV["HOME"], ".ssh_cap", "id_rsa_cap.pub")


set :walltime, ENV['walltime'] || XP5K::Config[:walltime] || "1:00:00"
set :nb_bootstraps, ENV['bootstraps'] || "1"
set :nb_groupmanagers, ENV['groupmanagers'] || "2"
set :nb_localcontrollers, ENV['localcontrollers'] || "2"
set :subnet, ENV['subnet'] || "slash_22"

