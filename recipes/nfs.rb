host = $myxp.get_assigned_nodes('bootstrap',kavlan="#{vlan}").first
nfs_shared = "/tmp/snooze24"
nfs_local = "/tmp/snooze24"
uid = "snoozeadmin"
gid = "snooze"
options = "rw,nfsvers=3,hard,intr,async,noatime,nodev,nosuid,auto,rsize=32768,wsize=32768"

namespace :storage do

  desc 'Deploy NFS on nodes'
  task :default do
    server
    client
  end

  desc 'Configure NFS server'
  task :server do
    template_server
    transfer_server
    apply_server
  end

  desc 'Configure NFS clients'
  task :client do 
    template_client
    transfer_client
    apply_client
  end

  task :template_server do
    template = File.read("templates/nfs-server.erb")
    renderer = ERB.new(template)
    @shared = "#{nfs_shared}"
    @uid = "#{uid}" 
    @gid = "#{gid}"
    generate = renderer.result(binding)
    myFile = File.open("tmp/nfs-server.pp", "w")
    myFile.write(generate)
    myFile.close 
  end

  task :transfer_server, :roles => [:frontend] do
    set :user, "#{g5k_user}"
    upload("tmp/nfs-server.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/nfs-server.pp")
  end

  task :apply_server, :roles => [:nfs_server] do
    set :user, "root"
      run "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/nfs-server.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
  end

  task :template_client do
    template = File.read("templates/nfs-client.erb")
    renderer = ERB.new(template)
    @nfshost = "#{host}"
    @shared = "#{nfs_shared}"
    @local  = "#{nfs_local}"
    @options = "#{options}"
    generate = renderer.result(binding)
    myFile = File.open("tmp/nfs-client.pp", "w")
    myFile.write(generate)
    myFile.close
  end

  task :transfer_client, :roles => [:frontend] do 
    set :user, "#{g5k_user}"
    upload("tmp/nfs-client.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/nfs-client.pp")
  end

  task :apply_client, :roles => [:localcontroller] do
    set :user, "root"
      run "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/nfs-client.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
  end

end
