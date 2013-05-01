require 'xp5k'
require 'erb'
load 'config/deploy.rb' 

XP5K::Config.load

myxp = XP5K::XP.new(:logger => logger)

myxp.define_job({
  :resources  => "nodes=1,walltime=1:00",
  :site       => XP5K::Config[:site] || 'rennes',
  :types      => ["deploy"],
  :name       => "bootstrap",
  :command    => "sleep 86400"
})

myxp.define_job({
  :resources  => "nodes=2,walltime=1:00",
  :site       => XP5K::Config[:site] || 'rennes',
  :types      => ["deploy"],
  :name       => "groupmanager",
  :command    => "sleep 86400"
})

myxp.define_job({
  :resources  => "nodes=1, walltime=1:00",
  :site       => XP5K::Config[:site] || 'rennes',
  :types      => ["deploy"],
  :name       => "localcontroller",
  :command    => "sleep 86400"
})

myxp.define_job({
  :resources  => "slash_22=1,walltime=1:00",
  :site       => XP5K::Config[:site] || 'rennes',
  :name       => "subnet",
  :command    => "sleep 86400"
})

myxp.define_deployment({
  :site           => XP5K::Config[:site] || 'rennes',
  :environment    => "wheezy-x64-nfs",
  :jobs           => %w{bootstrap groupmanager localcontroller},
  :key            => File.read(XP5K::Config[:public_key])
})

role :bootstrap do
  myxp.job_with_name('bootstrap')['assigned_nodes']
end

role :nfs_server do
  myxp.job_with_name('bootstrap')['assigned_nodes'].first
end

role :rabbitmq_server do
  myxp.job_with_name('bootstrap')['assigned_nodes'].first
end

role :groupmanager do
  myxp.job_with_name('groupmanager')['assigned_nodes']
end

role :localcontroller do
  myxp.job_with_name('localcontroller')['assigned_nodes']
end

role :frontend do
  XP5K::Config[:site] || 'rennes'
end


after "automatic","submit","deploy", "prepare", "bootstrap", "groupmanager", "localcontroller", "nfs", "cluster:start"
after "redeploy", "deploy", "prepare", "bootstrap", "groupmanager", "localcontroller", "nfs", "cluster:start"



desc 'automatic deploiement'
task :automatic do
  puts "####### Deploying Snooze #####"
  puts "This can be long :)"
end

desc 'redeploiement (not submitting new jobs)'
task :redeploy do
  puts "####### Redeploying Snooze #####"
  puts "This can be long :)"
end

desc 'Submit jobs'
task :submit do
  myxp.submit
end

desc 'Deploy with Kadeploy'
task :deploy  do
  myxp.deploy
end

desc 'Status'
task :status do
  myxp.status
end

desc 'Remove all running jobs'
task :clean do
  logger.debug "Clean all Grid'5000 running jobs..."
  myxp.clean
end

desc 'Run check command'
task :check, :roles=>[:bootstrap, :groupmanager, :localcontroller]  do
  set :user, 'root'
  run "tail -f /tmp/snooze_node.log" do |channel, stream, data|
      puts  
      puts "#{channel[:host]}: #{data}" 
      break if stream == :err    
  end
end

desc 'Give the ssh tunnel to the first bootstrap'
task :tunnel_bs, :roles=>[:bootstrap]  do
  print "###### First bootstrap ##### \n"
  set :first_bs, myxp.job_with_name('bootstrap')['assigned_nodes'].first
  puts "ssh -L 5000:#{first_bs}:5000 #{g5k_user}@access.grid5000.fr \n"
  print "###### First bootstrap ##### \n"
end

namespace :prepare do
  
  desc 'prepare the nodes'
  task :default do
    prepare
    puppet
  end
  desc 'Install puppet on hosts' 
  task :puppet, :roles=>[:groupmanager, :bootstrap, :localcontroller] do
    set :user, 'root'
    run "apt-get update" 
    run "apt-get install -y puppet"
end

  desc 'prepare environment'
  task :prepare, :roles => [:frontend] do
    set :user, "#{g5k_user}"
    puts "####### Downloading snooze-capistrano #####"
    ls = capture('ls snooze-capistrano &2>&1')
    puts ls
    if ls!=""
      run "mv snooze-capistrano snooze-capistrano"+Time.now.to_i.to_s 
    end
    run "https_proxy='http://proxy:3128' git clone  #{snooze_capistrano_repo_url}"
    run "cd snooze-capistrano ; https_proxy='http://proxy:3128' git submodule init"
    run "cd snooze-capistrano ; https_proxy='http://proxy:3128' git submodule update"
    run "https_proxy='http://proxy:3128' wget #{snoozenode_deb_url} -O snooze-capistrano/puppet/modules/snoozenode/files/snoozenode.deb &2>&1"
    run "https_proxy='http://proxy:3128' wget #{snoozenode_deb_url} -O snooze-capistrano/puppet/modules/snoozenode/files/snoozeclient.deb &2>&1"
  end

end


namespace :bootstrap do
  
  desc 'deploy the bootstrap nodes'
  task :default do
    template
    provision
  end
  
  desc 'Generate bootstrap.pp template and deploy it on the frontend'
  task :template, :roles => [:frontend] do
    set :user, "#{g5k_user}"
    @nodeType             = "bootstrap"
    @zookeeperHosts       = myxp.job_with_name('bootstrap')['assigned_nodes'].first
    @zookeeperdHosts      = myxp.job_with_name('bootstrap')['assigned_nodes'].first
    @virtualMachineSubnet = capture("g5k-subnets -p -j " + myxp.job_with_name('subnet')['uid'].to_s)

    template = File.read("templates/snoozenode.erb")
    renderer = ERB.new(template)
    generate = renderer.result(binding)
    myFile = File.open("puppet/manifests/bootstrap.pp", "w")
    myFile.write(generate)
    myFile.close
    upload("puppet/manifests/bootstrap.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/bootstrap.pp")
  end

  desc 'provision the bootstrap'
  task :provision , :roles => [:bootstrap] do
    set :user, 'root'
    run "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/bootstrap.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
  end

end # namespace bootstrap

namespace :groupmanager do

  desc 'Deploy the group manager nodes' 
  task :default do
    template
    provision
  end

  desc 'Generate groupmanager.pp template and deploy it on the frontend'
  task :template, :roles => [:frontend] do
    set :user, "#{g5k_user}"
    template = File.read("templates/snoozenode.erb")
    renderer = ERB.new(template)
    @nodeType = "groupmanager"
    @zookeeperHosts = myxp.job_with_name('bootstrap')['assigned_nodes'].first
    @zookeeperdHosts = myxp.job_with_name('bootstrap')['assigned_nodes'].first
    @virtualMachineSubnet = capture("g5k-subnets -p -j " + myxp.job_with_name('subnet')['uid'].to_s)

    generate = renderer.result(binding)
    myFile = File.open("puppet/manifests/groupmanager.pp", "w")
    myFile.write(generate)
    myFile.close
    upload("puppet/manifests/groupmanager.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/groupmanager.pp")
  end


  desc 'provision the groupmanagers'
  task :provision, :roles => [:groupmanager] do
    set :user, 'root'
    run "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/groupmanager.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
  end	

end # namespace groupmanager


namespace :localcontroller do

  desc 'Deploy the local controller nodes'
  task :default do
    template
    provision
    bridge_network 
 end
 
  
  desc 'Generate localcontroller.pp template and deploy it on the frontend'
  task :template, :roles => [:frontend] do
    set :user, "#{g5k_user}" 
    template = File.read("templates/snoozenode.erb")
    renderer = ERB.new(template)
    @nodeType = "localcontroller"
    @zookeeperHosts = myxp.job_with_name('bootstrap')['assigned_nodes'].first
    @zookeeperdHosts = myxp.job_with_name('bootstrap')['assigned_nodes'].first
    @virtualMachineSubnet = capture("g5k-subnets -p -j " + myxp.job_with_name('subnet')['uid'].to_s)

    generate = renderer.result(binding)
    myFile = File.open("puppet/manifests/localcontroller.pp", "w")
    myFile.write(generate)
    myFile.close
    upload("puppet/manifests/localcontroller.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/localcontroller.pp")
  end

  desc 'provision the local controllers'
  task :provision, :roles => [:localcontroller] do
    set :user, 'root'
    run "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/localcontroller.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
  end	

  desc 'Set up a bridge on hosts'
  task :bridge_network, :roles => [:localcontroller] do
    run "cp /home/#{g5k_user}/snooze-capistrano/network/interfaces /etc/network/interfaces"
    run "/home/#{g5k_user}/snooze-capistrano/network/configure_network.sh"
  end

end # namespace localcontroller    	

namespace :rabbit do
  desc 'Configure the rabbitmq server'
  task :default do
    server
  end

  desc 'Install Configure the rabbitmq server'
  task :server, :roles => [:rabbitmq_server] do
  set :user, "root"
    run "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/rabbitmq-server.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
  end
end

namespace :nfs do

  desc 'Configure the nfs storage'
  task :default do
    server
    template_client
    provision_client
  end
  
  desc 'Configure the nfs server'
  task :server, :roles => [:nfs_server] do
  set :user, "root"
    run "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/nfs-server.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
  end

  desc 'Configure the nfs clients (localcontroller)' 
  task :template_client, :roles => [:frontend] do
    set :user, "#{g5k_user}"
    template = File.read("templates/nfs-client.erb")
    renderer = ERB.new(template)
    @nfshost =  myxp.job_with_name('bootstrap')['assigned_nodes'].first
    generate = renderer.result(binding)
    myFile = File.open("puppet/manifests/nfs-client.pp", "w")
    myFile.write(generate)
    myFile.close
    upload("puppet/manifests/nfs-client.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/nfs-client.pp")
  end

  desc 'Provision the nfs client' 
  task :provision_client, :roles => [:localcontroller] do
  set :user, "root"
  run "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/nfs-client.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
  end

end # namespace nfs

namespace :cluster do
  desc 'Start cluster'
  task :start, :roles=>[:bootstrap, :groupmanager, :localcontroller] do
    set :user, "root"
    run "/etc/init.d/snoozenode restart" 
  end

  desc 'Stop cluster'
  task :stop, :roles=>[:bootstrap, :groupmanager, :localcontroller] do
    set :user, "root"
    run "/etc/init.d/snoozenode stop" 
  end

end
