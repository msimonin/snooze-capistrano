# apply a custom recipe (read from the environment variable recipe)

load 'config/deploy/xp5k/xp5k_sandbox.rb'

# load recipes
# don't forget to change stage to install specific version

recipe = ENV['recipe']
recipes = [recipe.to_s]

recipes.each do |recipe|
  load "#{recipes_path}/#{recipe}/recipe.rb"
end

desc 'Automatic deployment'
task :automatic do
  puts "Welcome to Snooze deployment".bold.blue
end

after "automatic", "xp5k", recipe.to_s
