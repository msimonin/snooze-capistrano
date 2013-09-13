checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
childmarkend = " #{prefixend} ".bold.blue
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green

before "keystone" do
  puts "Installing keystone server".bold.blue
end

before "keystone:puppet" do
  print " #{childmark}"
  print "Installing puppet........................"
  start_spinner()
end

after "keystone:puppet" do
  stop_spinner()
  puts "#{checkmark}"
end

before "keystone:generate" do
  print " #{childmark}"
  print "Generating rabbbitmq recipe.............."
end

after "keystone:generate" do
  puts "#{checkmark}"
end

before "keystone:modules:install" do
  print " #{childmark}"
  print "Installing rabbbitmq module.............."
end

after "keystone:modules:install" do
  puts "#{checkmark}"
end

before "keystone:transfer" do
  print " #{childmark}"
  print "Transfering rabbbitmq recipe............."
end

after "keystone:transfer" do
  puts "#{checkmark}"
end

before "keystone:modules:uninstall" do
  print " #{childmark}"
  print "Uninstalling rabbbitmq module............"
end


after "keystone:modules:uninstall" do
  puts "#{checkmark}"
end

before "keystone:apply" do
  print " #{childmarkend}"
  print "Installing / configuring rabbbitmq......."
  start_spinner()
end

after "keystone:apply" do
  stop_spinner()
  puts "#{checkmark}"
end

before "keystone:web_stomp_plugin" do
  print " #{childmarkend}"
  print "Installing / configuring rabbbitmq......."
  start_spinner()
end

after "keystone:web_stomp_plugin" do
  stop_spinner()
  puts "#{checkmark}"
end
