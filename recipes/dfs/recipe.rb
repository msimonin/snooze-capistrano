set :dfs_path, "#{recipes_path}/dfs"

load "#{dfs_path}/roles.rb"
load "#{dfs_path}/output.rb"


namespace :dfs do

  desc 'Deploy DFS on nodes'
  task :default do
    puppet
    generate
    transfer
    deploy
    template
    transfer_client
    modules
    apply
  end

  task :puppet, :roles => [:dfs_client, :dfs_data] do
    set :user, "root"
    run "apt-get -y install puppet 2>1"
  end

  desc 'Undeploy DFS on nodes'
  task :undeploy do
    unmount
    undeploy
  end

  task :generate do
    template = File.read("#{dfs_path}/templates/#{dfs_type}.erb")
    renderer = ERB.new(template)
    @master = dfs_master
    @master = "root@" + @master
    @datanodes = data_nodes
    @datanodes = @datanodes.map{|item| "root@"+item+":/tmp"}
    @clientnodes = client_nodes
    @clientnodes = @clientnodes.map{|item| "root@"+item }
    generate = renderer.result(binding)
    myFile = File.open("#{dfs_path}/tmp/#{dfs_type}", "w")
    myFile.write(generate)
    myFile.close
  end

  task :transfer, :roles => [:dfsfrontend] do
    set :user, "#{g5k_user}"
    upload("#{dfs_path}/tmp/#{dfs_type}","/home/#{g5k_user}/#{dfs_type}")  
  end

  task :deploy, :roles => [:dfsfrontend] do
    set :user, "#{g5k_user}"
    run "dfs5k -a deploy -s #{dfs_type} -f /home/#{g5k_user}/#{dfs_type}"
  end
 
  task :modules, :roles => [:dfs_client] do
    set :user, "root"
    upload("#{dfs_path}/module","/etc/puppet/modules/dfs", :via => :scp, :recursive => true)
  end
  
  task :template do
    template = File.read("#{dfs_path}/templates/dfs-client.erb")
    renderer = ERB.new(template)
    @dfstype = dfs_type
    @dfsmaster = dfs_master
    @volume = dfs_volume
    @local  = dfs_local
    generate = renderer.result(binding)
    myFile = File.open("#{dfs_path}/tmp/dfs-client.pp", "w")
    myFile.write(generate)
    myFile.close
  end

  task :transfer_client, :roles => [:dfs_client] do
   set :user, "root"
   upload("#{dfs_path}/tmp/dfs-client.pp","/tmp/dfs-client.pp")

  end

  desc 'Mount DFS'
  task :apply, :roles => [:dfs_client] do
    set :user, "root"
    run "puppet apply /tmp/dfs-client.pp"
  end
  
  desc 'Undeploy DFS'
  task :undeploy, :roles => [:dfsfrontend] do
    set :user, "#{g5k_user}"
    run "dfs5k -a undeploy -s #{dfs_type} -f /home/#{g5k_user}/#{dfs_type}"
  end

  desc 'Unmount DFS'
  task :unmount, :roles => [:dfsfrontend] do
    set :user, "#{g5k_user}"
    run "dfs5k -a unmount -s #{dfs_type} -f /home/#{g5k_user}/#{dfs_type}"
  end

end
