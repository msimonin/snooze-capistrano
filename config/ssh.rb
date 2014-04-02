# Capistrano parameters
set :g5k_user, "msimonin"
set :gateway, "#{g5k_user}@access.grid5000.fr"

# This key will used to access the gateway and nodes
ssh_options[:keys]= [File.join(ENV["HOME"], ".ssh", "id_rsa"), File.join(ENV["HOME"], ".ssh_insideg5k", "id_rsa"), File.join(ENV["HOME"], ".ssh", "id_rsa_insideg5k")]
# This key will be installed on nodes
set :ssh_public,  File.join(ENV["HOME"], ".ssh", "id_rsa_insideg5k.pub")

