require 'capistrano/ext/multistage'

# Stages definition
set :stages, %w(master v2.1.0 maint1.0.0 maint2.0.0 sandbox experimental)
set :default_stage, "v2.1.0"

# Enable pretty output. Remove it if you want full logging
# logger.level = Logger::IMPORTANT
STDOUT.sync
# Capistrano parameters
set :g5k_user, "msimonin"
set :gateway, "#{g5k_user}@access.grid5000.fr"
# This key will used to access the gateway and nodes
ssh_options[:keys]= [File.join(ENV["HOME"], ".ssh", "id_rsa"), File.join(ENV["HOME"], ".ssh_insideg5k", "id_rsa"), File.join(ENV["HOME"], ".ssh", "id_rsa_insideg5k")]
# This key will be installed on nodes
set :ssh_public,  File.join(ENV["HOME"], ".ssh_insideg5k", "id_rsa.pub")

# relative to the capfile
set :recipes_path, "./recipes"

# G5K global parameters
set :site, ENV['site'] || "rennes"
set :walltime, ENV['walltime'] || "3:00:00"
set :subnet, ENV['subnet'] || "slash_18"
set :vlan, ENV['vlan'] || "-1"
# For nodes reservation, see config/deploy/xp5k

