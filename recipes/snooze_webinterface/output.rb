checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
childmarkend = " #{prefixend} ".bold.blue
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green

before "snooze_webinterface" do
  puts "Installing RabbitMQ server".bold.blue
end

before "snooze_webinterface:puppet" do
  print " #{childmark}"
  print "Installing puppet........................"
  start_spinner()
end

after "snooze_webinterface:puppet" do
  stop_spinner()
  puts "#{checkmark}"
end

before "snooze_webinterface:generate" do
  print " #{childmark}"
  print "Generating rabbbitmq recipe.............."
end

after "snooze_webinterface:generate" do
  puts "#{checkmark}"
end

before "snooze_webinterface:modules:install" do
  print " #{childmark}"
  print "Installing rabbbitmq module.............."
end

after "snooze_webinterface:modules:install" do
  puts "#{checkmark}"
end

before "snooze_webinterface:transfer" do
  print " #{childmark}"
  print "Transfering rabbbitmq recipe............."
end

after "snooze_webinterface:transfer" do
  puts "#{checkmark}"
end

before "snooze_webinterface:modules:uninstall" do
  print " #{childmark}"
  print "Uninstalling rabbbitmq module............"
end


after "snooze_webinterface:modules:uninstall" do
  puts "#{checkmark}"
end

before "snooze_webinterface:apply" do
  print " #{childmarkend}"
  print "Installing / configuring rabbbitmq......."
  start_spinner()
end

after "snooze_webinterface:apply" do
  stop_spinner()
  puts "#{checkmark}"
end

before "snooze_webinterface:web_stomp_plugin" do
  print " #{childmarkend}"
  print "Installing / configuring rabbbitmq......."
  start_spinner()
end

after "snooze_webinterface:web_stomp_plugin" do
  stop_spinner()
  puts "#{checkmark}"
end
