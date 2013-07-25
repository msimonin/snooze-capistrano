checkmark = "\u2713"
prefix = "\u02EA"
childmark = " #{prefix} ".bold.blue

before "nfs" do
  puts "Installing NFS".bold.blue
end

before "nfs:puppet" do
  print " #{childmark}".blue
  print "Installing puppet........................"
  start_spinner()
end

after "nfs:puppet" do
  stop_spinner()
  puts "#{checkmark}".green
end

# MODULES
before "nfs:modules:install" do
  print " #{childmark}".blue
  print "Installing nfs module...................."
end

after "nfs:modules:install" do
  puts "#{checkmark}".green
end

before "nfs:modules:uninstall" do
  print " #{childmark}".blue
  print "Uninstalling nfs module.................."
end


after "nfs:modules:uninstall" do
  puts "#{checkmark}".green
end


# SERVER
before "nfs:server" do
  print " #{childmark}".blue
  puts "Installing NFS server".bold.blue
end

before "nfs:template_server" do
  print "   #{childmark}".blue
  print "Generating server recipe................."
end

after "nfs:template_server" do
  puts "#{checkmark}".green
end

before "nfs:transfer_server" do
  print "   #{childmark}".blue
  print "Transfering server recipe................"
end

after "nfs:transfer_server" do
  puts "#{checkmark}".green
end

before "nfs:apply_server" do
  print "   #{childmark}".blue
  print "Installing / Configuring nfs server ....."
  start_spinner()
end

after "nfs:apply_server" do
  stop_spinner()
  puts "#{checkmark}".green
end

# SLAVES
before "nfs:client" do
  print " #{childmark}".blue
  puts "Installing NFS slaves".bold.blue
end

before "nfs:template_client" do
  print "   #{childmark}".blue
  print "Generating client recipe................."
end

after "nfs:template_client" do
  puts "#{checkmark}".green
end

before "nfs:transfer_client" do
  print "   #{childmark}".blue
  print "Transfering client recipe................"
end

after "nfs:transfer_client" do
  puts "#{checkmark}".green
end

before "nfs:apply_client" do
  print "   #{childmark}".blue
  print "Installing / Configuring nfs client ....."
  start_spinner()
end

after "nfs:apply_client" do
  stop_spinner()
  puts "#{checkmark}".green
end

