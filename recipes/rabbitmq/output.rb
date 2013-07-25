checkmark = "\u2713"
prefix = "\u02EA"
childmark = " #{prefix} ".bold.blue

before "rabbitmq" do
  puts "Installing RabbitMQ server".bold.blue
end

before "rabbitmq:puppet" do
  print " #{childmark}".blue
  print "Installing puppet........................"
  start_spinner()
end

after "rabbitmq:puppet" do
  stop_spinner()
  puts "#{checkmark}".green
end

before "rabbitmq:generate" do
  print " #{childmark}".blue
  print "Generating rabbbitmq recipe.............."
end

after "rabbitmq:generate" do
  puts "#{checkmark}".green
end

before "rabbitmq:modules:install" do
  print " #{childmark}".blue
  print "Installing rabbbitmq module.............."
end

after "rabbitmq:modules:install" do
  puts "#{checkmark}".green
end

before "rabbitmq:transfer" do
  print " #{childmark}".blue
  print "Transfering rabbbitmq recipe............."
end

after "rabbitmq:transfer" do
  puts "#{checkmark}".green
end

before "rabbitmq:modules:uninstall" do
  print " #{childmark}".blue
  print "Uninstalling rabbbitmq module............"
end


after "rabbitmq:modules:uninstall" do
  puts "#{checkmark}".green
end

before "rabbitmq:apply" do
  print " #{childmark}".blue
  print "Installing / configuring rabbbitmq......."
  start_spinner()
end

after "rabbitmq:apply" do
  stop_spinner()
  puts "#{checkmark}".green
end
