require 'capistrano/ext/multistage'

set :stages, %w(master maint1.0.0 future)
set :default_stage, "master"

set :g5k_user, "msimonin"
set :gateway, "#{g5k_user}@access.grid5000.fr"
set :snooze_capistrano_repo_url, "https://github.com/msimonin/snooze-capistrano.git"
ssh_options[:keys]= [File.join(ENV["HOME"], ".ssh_cap", "id_rsa_cap"), File.join(ENV["HOME"], ".ssh", "id_rsa")]
