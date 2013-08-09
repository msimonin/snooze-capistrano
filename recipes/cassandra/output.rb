checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
childmark = " #{prefix} ".bold.blue
childmarkend = " #{prefixend} ".bold.blue
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green


before "cassandra" do
  puts "Installing Cassandra cluster".bold.blue
end

before "cassandra:puppet" do
  print " #{childmark}"
  print "Installing puppet........................"
  start_spinner()
end

after "cassandra:puppet" do
  stop_spinner()
  puts "#{checkmark}"
end

before "cassandra:generate" do
  print " #{childmark}"
  print "Generating cassandra recipe.............."
end

after "cassandra:generate" do
  puts "#{checkmark}"
end

before "cassandra:modules:install" do
  print " #{childmark}"
  print "Installing cassandra module.............."
end

after "cassandra:modules:install" do
  puts "#{checkmark}"
end

before "cassandra:transfer" do
  print " #{childmark}"
  print "Transfering cassandra recipe............."
end

after "cassandra:transfer" do
  puts "#{checkmark}"
end

before "cassandra:modules:uninstall" do
  print " #{childmark}"
  print "Uninstalling cassandra module............"
end


after "cassandra:modules:uninstall" do
  puts "#{checkmark}"
end

before "cassandra:apply" do
  print " #{childmark}"
  print "Installing /configuring cassandra........"
  start_spinner()
end

after "cassandra:apply" do
  stop_spinner()
  puts "#{checkmark}"
end

before "cassandra:schema" do
  print " #{childmark}"
  print "Installing database schema..............."
  start_spinner()
end

after "cassandra:schema" do
  stop_spinner()
  puts "#{checkmark}"
end

before "cassandra:opscenter" do
  print " #{childmarkend}"
  print "Installing opscenter....................."
  start_spinner()
end

after "cassandra:opscenter" do
  stop_spinner()
  puts "#{checkmark}"
  puts "/Reminder : need further configuration/".red
end





