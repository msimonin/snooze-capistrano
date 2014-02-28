checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
childmarkend = " #{prefixend} ".bold.blue
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green

before "openvswitch" do
  puts "Installing Openvswitch".bold.blue
end

before "openvswitch:install" do
  print " #{childmark}"
  print "Installing install........................"
  start_spinner()
end

after "openvswitch:install" do
  stop_spinner()
  puts "#{checkmark}"
end

before "openvswitch:build" do
  print " #{childmark}"
  print "Generating openvswitch module .............."
end

after "openvswitch:build" do
  puts "#{checkmark}"
end

before "openvswitch:bridge" do
  print " #{childmark}"
  print "Bridging.............."
end

after "openvswitch:bridge" do
  puts "#{checkmark}"
end

