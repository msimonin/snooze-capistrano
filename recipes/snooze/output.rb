checkmark = "\u2713"
prefix = "\u02EA"
childmark = " #{prefix} ".bold.blue

before "snooze" do
  puts "Installing Snooze cluster".bold.blue
end

before "snooze:prepare" do
  print " #{childmark}".blue
  puts "Preparing nodes".blue
end

before "snooze:prepare:puppet" do
  print "   #{childmark}".blue
  print "Installing puppet........................"
  start_spinner()
end

after "snooze:prepare:puppet" do
  stop_spinner()
  puts "#{checkmark}".green
end

before "snooze:prepare:modules" do
  print "   #{childmark}".blue
  print "Installing modules......................."
  start_spinner()
end

after "snooze:prepare:modules" do
  stop_spinner()
  puts "#{checkmark}".green
end

before "snooze:provision" do
  print " #{childmark}".blue
  puts "Provision snooze cluster".blue
end

before "snooze:provision:template" do
  print "   #{childmark}".blue
  print "Generating snooze recipes................"
end

after "snooze:provision:template" do
  puts "#{checkmark}".green
end

before "snooze:provision:transfer" do
  print "   #{childmark}".blue
  print "Transfering snooze recipes..............."
end

after "snooze:provision:transfer" do
  puts "#{checkmark}".green
end

before "snooze:provision:apply" do
  print "   #{childmark}".blue
  print "Installing / Configuring nodes..........."
  start_spinner()
end

after "snooze:provision:apply" do
  stop_spinner()
  puts "#{checkmark}".green
end

## Cluster
before "cluster" do
  puts "Preparing Snooze cluster".bold.blue
end

before "snooze:cluster:bridge_network" do
  print " #{childmark}".blue
  print "Bridging network........................."
  start_spinner()
end

after "snooze:cluster:bridge_network" do
  stop_spinner()
  puts "#{checkmark}".green
end

before "snooze:cluster:prepare" do
  print " #{childmark}".blue
  print "Copying experiments script..............."
end

after "snooze:cluster:prepare" do
  puts "#{checkmark}".green
end

before "snooze:cluster:copy" do
  print " #{childmark}".blue
  print "Copying base image........................"
  start_spinner()
end

after "snooze:cluster:copy" do
  stop_spinner()
  puts "#{checkmark}".green
end

before "snooze:cluster:interfaces" do
  print " #{childmark}".blue
  print "Preparing vm iso  context................."
end

after "snooze:cluster:context" do
  puts "#{checkmark}".green
end

