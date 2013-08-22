load 'config/deploy/xp5k/xp5k_sandbox.rb'

# load recipes
# don't forget to change stage to install specific version
recipes = ["cassandra"]

recipes.each do |recipe|
  load "#{recipes_path}/#{recipe}/recipe.rb"
end

desc 'Automatic deployment'
task :automatic do
  puts "Welcome to Snooze deployment".bold.blue
end

after "automatic", "xp5k", "cassandra"