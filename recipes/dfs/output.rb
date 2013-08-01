checkmark = "\u2713"
prefixend = "\u2514"
prefix = "\u251C"
childmarkend = " #{prefixend} ".bold.blue
childmark = " #{prefix} ".blue.bold
checkmark = "#{checkmark}".green


before "dfs" do
  puts  "Installing dfs on nodes".blue.bold
end

before "dfs:puppet" do
  print " #{childmark}"
  print "Installing puppet on nodes..............."
  start_spinner()
end

after "dfs:puppet" do
  stop_spinner()
  puts "#{checkmark}"
end


before "dfs:generate" do
  print " #{childmark}"
  print "Deploying dfs from frontend..............."
  start_spinner()
end

after "dfs:deploy" do
  stop_spinner()
  puts "#{checkmark}"
end

before "dfs:template" do
  print " #{childmarkend}"
  print "Mounting dfs on nodes....................."
  start_spinner()
end

after "dfs:apply" do
  stop_spinner()
  puts "#{checkmark}"
end

