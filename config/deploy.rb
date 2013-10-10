require 'capistrano/ext/multistage'

# Stages definition
set :stages, %w(master maint1.0.0 maint2.0.0 testing sandbox)
set :default_stage, "master"

# Enable pretty output. Remove it if you want full logging
# logger.level = Logger::IMPORTANT
STDOUT.sync


# Capistrano parameters
set :g5k_user, "msimonin"
set :gateway, "#{g5k_user}@access.grid5000.fr"
set :snooze_capistrano_repo_url, "https://github.com/msimonin/snooze-capistrano.git"
set :snooze_puppet_repo_url, "https://github.com/msimonin/snooze-puppet.git"
set :snooze_experiments_repo_url, "https://github.com/snoozesoftware/snooze-experiments"
# This key will used to access the gateway and nodes
ssh_options[:keys]= [File.join(ENV["HOME"], ".ssh", "id_rsa"), File.join(ENV["HOME"], ".ssh_insideg5k", "id_rsa")]
# This key will be installed on nodes
set :ssh_public,  File.join(ENV["HOME"], ".ssh_insideg5k", "id_rsa.pub")

# relative to the capfile
set :recipes_path, "./recipes"

set :site, ENV['site'] || XP5K::Config[:site] || "rennes"
set :walltime, ENV['walltime'] || XP5K::Config[:walltime] || "6:00:00"
set :subnet, ENV['subnet'] || "slash_18"
set :vlan, ENV['vlan'] || "-1"
