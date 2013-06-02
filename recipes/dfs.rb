#
# Fill your specific parameters below
#

#dfs_master = $myxp.get_assigned_nodes('bootstrap', kavlan="#{vlan}").first
load "recipes/dfs_functions.rb"
=begin
def dfs_master
 $myxp.get_assigned_nodes('bootstrap', kavlan="#{vlan}").first
end
def dfs_type()
  "glusterfs"
end

def dfs_volume()
  "/G5K_Gluster"
end

def data_nodes()
  $myxp.get_assigned_nodes('groupmanager', kavlan="#{vlan}")
end

def client_nodes()
  $myxp.get_assigned_nodes('localcontroller', kavlan="#{vlan}")
end

def dfs_local()
  "/tmp/snooze"
end

# dfs5k can be called from any frontend 
role :singlefrontend do
  %w( reims )
end

role :client do
  client_nodes
end
=end
#
# Main recipe below
#

namespace :storage do

  desc 'Deploy DFS on nodes'
  task :default do
    generate
    transfer
    deploy
    template
    transfer_client
    apply
  end

  desc 'Undeploy DFS on nodes'
  task :undeploy do
    unmount
    undeploy
  end

  desc 'Generate DFS config file' 
  task :generate do
    template = File.read("templates/#{dfs_type}.erb")
    renderer = ERB.new(template)
    @master = dfs_master
    @master = "root@" + @master
    @datanodes = data_nodes
    @datanodes = @datanodes.map{|item| "root@"+item+":/tmp"}
    @clientnodes = client_nodes
    @clientnodes = @clientnodes.map{|item| "root@"+item }
    generate = renderer.result(binding)
    myFile = File.open("tmp/#{dfs_type}", "w")
    myFile.write(generate)
    myFile.close
  end

  desc 'Transfer the config file'
  task :transfer, :roles => [:singlefrontend] do
    set :user, "#{g5k_user}"
    upload("tmp/#{dfs_type}","/home/#{g5k_user}/#{dfs_type}")  
  end

  desc 'Deploy DFS'
  task :deploy, :roles => [:singlefrontend] do
    set :user, "#{g5k_user}"
    run "dfs5k -a deploy -s #{dfs_type} -f /home/#{g5k_user}/#{dfs_type}"
  end
  
  task :template do
    template = File.read("templates/dfs-client.erb")
    renderer = ERB.new(template)
    @dfstype = dfs_type
    @dfsmaster = dfs_master
    @volume = dfs_volume
    @local  = dfs_local
    generate = renderer.result(binding)
    myFile = File.open("tmp/dfs-client.pp", "w")
    myFile.write(generate)
    myFile.close
  end

  task :transfer_client, :roles => [:frontend] do
   set :user, "#{g5k_user}"
   upload("tmp/dfs-client.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/dfs-client.pp")

  end

  desc 'Mount DFS'
  task :apply, :roles => [:client] do
    set :user, "root"
#    run "dfs5k -a mount -s glusterfs -f /home/#{g5k_user}/glusterfs"
    run "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/dfs-client.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
  end
  
  desc 'Undeploy DFS'
  task :undeploy, :roles => [:singlefrontend] do
    set :user, "#{g5k_user}"
    run "dfs5k -a undeploy -s #{dfs_type} -f /home/#{g5k_user}/#{dfs_type}"
  end

  desc 'Unmount DFS'
  task :unmount, :roles => [:singlefrontend] do
    set :user, "#{g5k_user}"
    run "dfs5k -a unmount -s #{dfs_type} -f /home/#{g5k_user}/#{dfs_type}"
  end

end
