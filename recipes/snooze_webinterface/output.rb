checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
prefixl1 = "*"
firstchildmark = " #{prefixl1} ".bold.blue
childmarkend = " #{prefixend} ".bold.blue
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green

before "snooze_webinterface" do
  puts "Installing Snoozewebinterface".bold.blue
end

before "snooze_webinterface:install:packages" do
  print "   #{childmark}"
  print "Installing packages......................"
  start_spinner()
end

after "snooze_webinterface:install:packages" do
  stop_spinner()
  puts "#{checkmark}"
end

before "snooze_webinterface:install:files" do
  print "   #{childmark}"
  print "Installing snoozeweb files..............."
  start_spinner()
end

after "snooze_webinterface:install:files" do
  stop_spinner()
  puts "#{checkmark}"
end

before "snooze_webinterface:install:bundle" do
  print "   #{childmark}"
  print "Installing gems........................."
  start_spinner()
end

after "snooze_webinterface:install:gems" do
  stop_spinner()
  puts "#{checkmark}"
end

before "snooze_webinterface:launch" do
  print "   #{childmark}"
  print "Launching..............................."
  start_spinner()
end

after "snooze_webinterface:launch" do
  stop_spinner()
  puts "#{checkmark}"
end
