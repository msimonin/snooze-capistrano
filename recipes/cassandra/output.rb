checkmark = "\u2713"
prefix = "\u02EA"
childmark = " #{prefix} ".bold.blue

before "cassandra" do
  puts "Installing Cassandra cluster".bold.blue
end

before "cassandra:puppet" do
  print " #{childmark}".blue
  print "Installing puppet........................"
  start_spinner()
end

after "cassandra:puppet" do
  stop_spinner()
  puts "#{checkmark}".green
end

before "cassandra:generate" do
  print " #{childmark}".blue
  print "Generating cassandra recipe.............."
end

after "cassandra:generate" do
  puts "#{checkmark}".green
end

before "cassandra:modules:install" do
  print " #{childmark}".blue
  print "Installing cassandra module.............."
end

after "cassandra:modules:install" do
  puts "#{checkmark}".green
end

before "cassandra:transfer" do
  print " #{childmark}".blue
  print "Transfering cassandra recipe............."
end

after "cassandra:transfer" do
  puts "#{checkmark}".green
end

before "cassandra:modules:uninstall" do
  print " #{childmark}".blue
  print "Uninstalling cassandra module............"
end


after "cassandra:modules:uninstall" do
  puts "#{checkmark}".green
end

before "cassandra:apply" do
  print " #{childmark}".blue
  print "Installing /configuring cassandra........"
  start_spinner()
end

after "cassandra:apply" do
  stop_spinner()
  puts "#{checkmark}".green
end

before "cassandra:schema" do
  print " #{childmark}".blue
  print "Installing database schema..............."
  start_spinner()
end

after "cassandra:schema" do
  stop_spinner()
  puts "#{checkmark}".green
end

before "cassandra:opscenter" do
  print " #{childmark}".blue
  print "Installing opscenter....................."
  start_spinner()
end

after "cassandra:opscenter" do
  stop_spinner()
  puts "#{checkmark}".green
  puts "/Reminder : need further configuration/".red
end





