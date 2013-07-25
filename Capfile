require 'bundler/setup'
require 'rubygems'
require 'xp5k'
require 'erb'
require 'colored'

load 'config/deploy.rb' 
load 'config/lib/spinner.rb'


# submission / roles definition
load 'xp5k.rb'

# load recipes
# don't forget to change stage to install specific version
recipes = ["rabbitmq", "cassandra", "nfs", "snooze"]

recipes.each do |recipe|
  load "#{recipes_path}/#{recipe}/recipe.rb"
end

desc 'Automatic deployment'
task :automatic do
   puts "Welcome to Snooze deployment".bold.blue
end

after "automatic", "xp5k", "rabbitmq", "cassandra", "nfs", "snooze"
