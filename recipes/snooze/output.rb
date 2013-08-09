checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
prefixl1 = "*"
firstchildmark = " #{prefixl1} ".bold.blue
childmarkend = " #{prefixend} ".bold.blue
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green


before "snooze" do
  puts "Installing Snooze cluster".bold.blue
end

before "snooze:prepare" do
  print " #{firstchildmark}"
  puts "Preparing nodes"
end

before "snooze:prepare:puppet" do
  print "   #{childmark}"
  print "Installing puppet........................"
  start_spinner()
end

after "snooze:prepare:puppet" do
  stop_spinner()
  puts "#{checkmark}"
end

before "snooze:prepare:modules" do
  print "   #{childmark}"
  print "Installing modules......................."
  start_spinner()
end

after "snooze:prepare:modules" do
  stop_spinner()
  puts "#{checkmark}"
end

before "snooze:provision" do
  print " #{firstchildmark}"
  puts "Provision snooze cluster"
end

before "snooze:provision:template" do
  print "   #{childmark}"
  print "Generating snooze recipes................"
end

after "snooze:provision:template" do
  puts "#{checkmark}"
end

before "snooze:provision:transfer" do
  print "   #{childmark}"
  print "Transfering snooze recipes..............."
end

after "snooze:provision:transfer" do
  puts "#{checkmark}"
end

before "snooze:provision:apply" do
  print "   #{childmark}"
  print "Installing / Configuring nodes..........."
  start_spinner()
end

after "snooze:provision:apply" do
  stop_spinner()
  puts "#{checkmark}"
end

## Cluster
before "snooze:cluster" do
  print " #{firstchildmark}"
  puts "Preparing Snooze cluster".bold.blue
end

before "snooze:cluster:bridge_network" do
  print "   #{childmark}"
  print "Bridging network........................."
  start_spinner()
end

after "snooze:cluster:bridge_network" do
  stop_spinner()
  puts "#{checkmark}"
end

before "snooze:cluster:prepare" do
  print "   #{childmark}"
  print "Copying experiments script..............."
end

after "snooze:cluster:prepare" do
  puts "#{checkmark}"
end

before "snooze:cluster:copy" do
  print "   #{childmark}"
  print "Copying base image........................"
  start_spinner()
end

after "snooze:cluster:copy" do
  stop_spinner()
  puts "#{checkmark}"
end

before "snooze:cluster:interfaces" do
  print "   #{childmark}"
  print "Preparing vm iso  context................."
end

after "snooze:cluster:context" do
  puts "#{checkmark}"
end

