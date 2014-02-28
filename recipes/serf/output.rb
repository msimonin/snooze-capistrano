checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
childmarkend = " #{prefixend} ".bold.blue
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green

before "serf" do
  puts "Installing Openvswitch".bold.blue
end

before "serf:prepare" do
  print " #{childmark}"
  print "Installing install........................"
  start_spinner()
end

after "serf:prepare" do
  stop_spinner()
  puts "#{checkmark}"
end

before "serf:install" do
  print " #{childmark}"
  print "Generating serf module .............."
end

after "serf:install" do
  puts "#{checkmark}"
end
