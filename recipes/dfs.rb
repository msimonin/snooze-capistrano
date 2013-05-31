puts "in dfs recipe"
namespace :storage do

  desc 'Deploy Glusterfs on nodes'
  task :default do
    generate
    transfer
    deploy
    mount
  end

  desc 'Undeploy Glusterfs on nodes'
  task :undeploy do
    unmount
    undeploy
  end

  desc 'Generate GlusterFS config file' 
  task :generate do
    template = File.read("templates/glusterfs.erb")
    renderer = ERB.new(template)
    @master = $myxp.get_assigned_nodes('bootstrap', kavlan="#{vlan}").first
    @master = "root@" + @master
    @datanodes = $myxp.get_assigned_nodes('groupmanager', kavlan="#{vlan}").clone
    @datanodes.map!{|item| "root@"+item+":/tmp"}
    @clientnodes = $myxp.get_assigned_nodes('localcontroller', kavlan="#{vlan}").clone
    @clientnodes.map!{|item| "root@"+item }
    generate = renderer.result(binding)
    myFile = File.open("tmp/glusterfs", "w")
    myFile.write(generate)
    myFile.close
  end

  desc 'Transfer the config file'
  task :transfer, :roles => [:singlefrontend] do
    set :user, "#{g5k_user}"
    upload("tmp/glusterfs","/home/#{g5k_user}/glusterfs")  
  end

  desc 'Deploy Glusterfs'
  task :deploy, :roles => [:singlefrontend] do
    set :user, "#{g5k_user}"
    run "dfs5k -a deploy -s glusterfs -f /home/#{g5k_user}/glusterfs"
  end

  desc 'Mount Glusterfs'
  task :mount, :roles => [:localcontroller] do
    set :user, "root"
    #run "dfs5k -a mount -s glusterfs -f /home/#{g5k_user}/glusterfs"
    @master = $myxp.get_assigned_nodes('bootstrap', kavlan="#{vlan}").first
    puts "mount -t glusterfs #{@master}:/G5K_Gluster /tmp/snooze "
    run "mount -t glusterfs #{@master}:/G5K_Gluster /tmp/snooze "
  end
  
  desc 'Undeploy Glusterfs'
  task :undeploy, :roles => [:singlefrontend] do
    set :user, "#{g5k_user}"
    run "dfs5k -a undeploy -s glusterfs -f /home/#{g5k_user}/glusterfs"
  end

  desc 'Unmount Glusterfs'
  task :unmount, :roles => [:frontend] do
    set :user, "#{g5k_user}"
    run "dfs5k -a unmount -s glusterfs -f /home/#{g5k_user}/glusterfs"
    #run "dfs5k -a unmount -s glusterfs -f /home/#{g5k_user}/glusterfs"
  end

end
