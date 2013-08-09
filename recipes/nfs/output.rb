checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
childmarkend = " #{prefixend} ".blue.bold
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green

before "nfs" do
  puts "Installing NFS".bold.blue
end

before "nfs:puppet" do
  print " #{childmark}"
  print "Installing puppet........................"
  start_spinner()
end

after "nfs:puppet" do
  stop_spinner()
  puts "#{checkmark}"
end

# MODULES
before "nfs:modules:install" do
  print " #{childmark}"
  print "Installing nfs module...................."
end

after "nfs:modules:install" do
  puts "#{checkmark}"
end

before "nfs:modules:uninstall" do
  print " #{childmark}"
  print "Uninstalling nfs module.................."
end


after "nfs:modules:uninstall" do
  puts "#{checkmark}"
end


# SERVER
before "nfs:server" do
  print " #{childmark}"
  puts "Installing NFS server".bold
end

before "nfs:template_server" do
  print "   #{childmark}"
  print "Generating server recipe................."
end

after "nfs:template_server" do
  puts "#{checkmark}"
end

before "nfs:transfer_server" do
  print "   #{childmark}"
  print "Transfering server recipe................"
end

after "nfs:transfer_server" do
  puts "#{checkmark}"
end

before "nfs:apply_server" do
  print "   #{childmark}"
  print "Installing / Configuring nfs server ....."
  start_spinner()
end

after "nfs:apply_server" do
  stop_spinner()
  puts "#{checkmark}"
end

# SLAVES
before "nfs:client" do
  print " #{childmark}"
  puts "Installing NFS slaves".bold
end

before "nfs:template_client" do
  print "   #{childmark}"
  print "Generating client recipe................."
end

after "nfs:template_client" do
  puts "#{checkmark}"
end

before "nfs:transfer_client" do
  print "   #{childmark}"
  print "Transfering client recipe................"
end

after "nfs:transfer_client" do
  puts "#{checkmark}"
end

before "nfs:apply_client" do
  print "   #{childmark}"
  print "Installing / Configuring nfs client ....."
  start_spinner()
end

after "nfs:apply_client" do
  stop_spinner()
  puts "#{checkmark}"
end

