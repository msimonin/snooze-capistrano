checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
childmarkend = " #{prefixend} ".bold.blue
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green

before "rabbitmq" do
  puts "Installing RabbitMQ server".bold.blue
end

before "rabbitmq:puppet" do
  print " #{childmark}"
  print "Installing puppet........................"
  start_spinner()
end

after "rabbitmq:puppet" do
  stop_spinner()
  puts "#{checkmark}"
end

before "rabbitmq:generate" do
  print " #{childmark}"
  print "Generating rabbbitmq recipe.............."
end

after "rabbitmq:generate" do
  puts "#{checkmark}"
end

before "rabbitmq:modules:install" do
  print " #{childmark}"
  print "Installing rabbbitmq module.............."
end

after "rabbitmq:modules:install" do
  puts "#{checkmark}"
end

before "rabbitmq:transfer" do
  print " #{childmark}"
  print "Transfering rabbbitmq recipe............."
end

after "rabbitmq:transfer" do
  puts "#{checkmark}"
end

before "rabbitmq:modules:uninstall" do
  print " #{childmark}"
  print "Uninstalling rabbbitmq module............"
end


after "rabbitmq:modules:uninstall" do
  puts "#{checkmark}"
end

before "rabbitmq:apply" do
  print " #{childmarkend}"
  print "Installing / configuring rabbbitmq......."
  start_spinner()
end

after "rabbitmq:apply" do
  stop_spinner()
  puts "#{checkmark}"
end
