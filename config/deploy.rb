require 'capistrano/ext/multistage'

# Stages definition
set :stages, %w(master latest develop experimental sandbox serfdom)
set :default_stage, "latest"

# relative to the capfile
set :recipes_path, "./recipes"

# Enable pretty output. Remove it if you want full logging
#logger.level = Logger::IMPORTANT
#STDOUT.sync
