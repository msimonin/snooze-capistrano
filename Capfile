require 'bundler/setup'
require 'rubygems'
require 'xp5k'
require 'erb'
load 'config/deploy.rb' 

XP5K::Config.load

$myxp = XP5K::XPM.new(:logger => logger)

$myxp.define_job({
  :resources  => ["nodes=#{nb_bootstraps}, walltime=#{walltime}"],
  :sites      => %w( rennes ),
  :types      => ["deploy"],
  :name       => "bootstrap",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  =>["nodes=#{nb_groupmanagers}, walltime=#{walltime}"],
  :sites      => %w( rennes sophia lille ) ,
  :types      => ["deploy"],
  :name       => "groupmanager",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  => ["nodes=2, walltime=#{walltime}"],
  :sites       => %w( rennes sophia nancy ),
  :types      => ["deploy"],
  :name       => "localcontroller",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  => ["nodes=2, walltime=#{walltime}"],
  :sites       => %w( rennes nancy sophia ),
  :types      => ["deploy"],
  :name       => "dfs",
  :command    => "sleep 86400"
})
=begin
$myxp.define_job({
  :resources  => ["#{subnet}=1, walltime=#{walltime}"],
  :sites       => %w( rennes ),
  :name       => "subnet",
  :command    => "sleep 86400"
})
=end
$myxp.define_job({
  :resources  => ["{type='kavlan-global'}vlan=1, walltime=#{walltime}"],
  :sites       => %w( sophia ),
  :name       => "kavlan",
  :command    => "sleep 86400"
})

$myxp.define_deployment({
  :environment    => "wheezy-x64-nfs",
  :jobs           => %w{bootstrap groupmanager localcontroller dfs},
  :key            => File.read("#{ssh_public}"), 
  :vlan           => "#{vlan}"
})

role :bootstrap do
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end

role :first_bootstrap do
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end

role :nfs_server do
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end

role :rabbitmq_server do
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end

role :groupmanager do
  $myxp.get_deployed_nodes('groupmanager', kavlan="#{vlan}")
end

role :localcontroller do
  $myxp.get_deployed_nodes('localcontroller', kavlan="#{vlan}")
end

role :frontend do
  $myxp.get_sites_with_jobs()
end

role :subnet do
  %w( sophia )
end

load 'recipes/dfs.rb'

after "automatic","submit","deploy", "prepare","storage", "rabbit", "provision","cluster"

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
  $myxp.submit
end

desc 'Deploy with Kadeploy'
task :deploy  do
  $myxp.deploy
end

desc 'Status'
task :status do
  $myxp.status
end

desc 'Remove all running jobs'
task :clean do
  logger.debug "Clean all Grid'5000 running jobs..."
  $myxp.clean
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
  set :first_bs, $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first
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
    run "cd snooze-capistrano ; https_proxy='http://proxy:3128' git clone #{snooze_puppet_repo_url} puppet" 
    run "cd snooze-capistrano/puppet ; http_proxy='http://proxy:3128' rake modules:clone"
    run "https_proxy='http://proxy:3128' wget #{snoozenode_deb_url} -O snooze-capistrano/puppet/modules/snoozenode/files/snoozenode.deb &2>&1"
    run "https_proxy='http://proxy:3128' wget #{snoozeclient_deb_url} -O snooze-capistrano/puppet/modules/snoozeclient/files/snoozeclient.deb &2>&1"
  end

end

namespace :provision do
  
  desc 'Provision all the nodes'
  task :default do
    template
    transfer
    provision 
  end

  desc 'Generate templates for all nodes'
  task :template, :roles => [:subnet] do
    set :user, "#{g5k_user}"
    if "#{vlan}"=="-1"
      @virtualMachineSubnets = capture("g5k-subnets -p -j " + $myxp.job_with_name('subnet')['uid'].to_s).split
    else
      # generate subnets according to the kavlan id
      kavlan = capture("kavlan -V -j " + $myxp.job_with_name('kavlan')['uid'].to_s)
      b=(kavlan.to_i-10)*4+3
      @virtualMachineSubnets = (216..255).step(2).to_a.map{|x| "10."+b.to_s+"."+x.to_s+".1/23"} 
    end
    bootstrap
    groupmanager
    localcontroller
  end

  desc 'transfer templates for all nodes'
  task :transfer, :roles => [:frontend] do
    set :user, "#{g5k_user}"
    upload("tmp/bootstrap.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/bootstrap.pp")
    upload("tmp/groupmanager.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/groupmanager.pp")
    upload("tmp/localcontroller.pp","/home/#{g5k_user}/snooze-capistrano/puppet/manifests/localcontroller.pp")
  end


  desc 'Generate template for bootstrap'
  task :bootstrap do
    template = File.read("templates/snoozenode.erb")
    renderer = ERB.new(template)
    @nodeType             = "bootstrap"
    @zookeeperHosts       = $myxp.get_assigned_nodes("bootstrap", kavlan="#{vlan}").first
    @zookeeperdHosts      = $myxp.get_assigned_nodes("bootstrap", kavlan="#{vlan}").first
    @externalNotificationHost = $myxp.get_assigned_nodes("bootstrap", kavlan="#{vlan}").first 
    generate = renderer.result(binding)
    myFile = File.open("tmp/bootstrap.pp", "w")
    myFile.write(generate)
    myFile.close
  end

  desc 'Generate template for groupmanager'
  task :groupmanager do
    template = File.read("templates/snoozenode.erb")
    renderer = ERB.new(template)
    @nodeType             = "groupmanager"
    @zookeeperHosts       = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first
    @zookeeperdHosts      = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first
    @externalNotificationHost = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first 
    generate = renderer.result(binding)
    myFile = File.open("tmp/groupmanager.pp", "w")
    myFile.write(generate)
    myFile.close
  end


  desc 'Generate template for localcontroller'
  task :localcontroller do
    template = File.read("templates/snoozenode.erb")
    renderer = ERB.new(template)
    @nodeType             = "localcontroller"
    @zookeeperHosts       = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first
    @zookeeperdHosts      = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first
    @externalNotificationHost = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first 
    generate = renderer.result(binding)
    myFile = File.open("tmp/localcontroller.pp", "w")
    myFile.write(generate)
    myFile.close
  end

  desc 'provision all the nodes'
  task :provision, :roles => [:bootstrap, :groupmanager, :localcontroller] do
    set :user, 'root'
    parallel do |session|
      session.when "in?(:bootstrap)", "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/bootstrap.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
      session.when "in?(:groupmanager)", "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/groupmanager.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
      session.when "in?(:localcontroller)", "puppet apply /home/#{g5k_user}/snooze-capistrano/puppet/manifests/localcontroller.pp --modulepath=/home/#{g5k_user}/snooze-capistrano/puppet/modules/"
    end
  end 

end

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

namespace :cluster do

  desc 'Configure the cluster'
  task :default do
    bridge_network
    prepare
    copy
    interfaces
    transfer
    context
    fix_permissions
  end


  desc 'Set up a bridge on hosts'
  task :bridge_network, :roles => [:localcontroller] do
    set :user, 'root'
    run "cp /home/#{g5k_user}/snooze-capistrano/network/interfaces /etc/network/interfaces"
    run "/home/#{g5k_user}/snooze-capistrano/network/configure_network.sh"
   end


  desc 'Start cluster'
  task :start, :roles=>[:bootstrap, :groupmanager, :localcontroller] do
    set :user, "root"
    run "/etc/init.d/snoozenode start" 
  end

  desc 'Stop cluster'
  task :stop, :roles=>[:bootstrap, :groupmanager, :localcontroller] do
    set :user, "root"
    run "/etc/init.d/snoozenode stop" 
  end

  desc 'Copy experiments and base image file'
  task :prepare, :roles=>[:nfs_server] do
    set :user, "root"
    run "https_proxy='http://proxy:3128' git clone  #{snooze_experiments_repo_url} /tmp/snoozedeploy" 
    run "cp -r /tmp/snoozedeploy/grid5000/experiments /tmp/snooze"
  end

  desc 'Copy base image'
  task :copy, :roles=>[:nfs_server] do
    set :user, "root"
    run "mkdir -p /tmp/snooze/images"
    run "cd /tmp/snooze/images ; https_proxy='http://proxy:3128' wget -O /tmp/snooze/images/debian-hadoop-context-big.qcow2 http://public.rennes.grid5000.fr/~msimonin/debian-hadoop-context-big.qcow2"
  end
  
  desc 'Interface contextualization generation'
  task :interfaces, :roles=>[:subnet] do
    set :user, "#{g5k_user}"
    if "#{vlan}"=="-1" 
      subnet_id = $myxp.job_with_name('subnet')['uid'].to_s
      @gateway=capture("g5k-subnets -j "+subnet_id+" -a | head -n 1 | awk '{print $4}'")
      @network=capture("g5k-subnets -j "+subnet_id+" -a | head -n 1 | awk '{print $5}'")
      @broadcast=capture("g5k-subnets -j "+subnet_id+" -a | head -n 1 | awk '{print $2}'")
      @netmask=capture("g5k-subnets -j "+subnet_id+" -a | head -n 1 | awk '{print $3}'")
      @nameserver=capture("g5k-subnets -j "+subnet_id+" -a | head -n 1 | awk '{print $4}'")
    else
      kavlan = capture("kavlan -V -j " + $myxp.job_with_name('kavlan')['uid'].to_s)
      b=(kavlan.to_i-10)*4+3
      @gateway="10."+b.to_s+".255.254"
      @network="10."+b.to_s+".192.0"
      @broadcast="10."+b.to_s+".255.255"
      @netmask="255.255.192.0"
      @nameserver="131.254.203.235"
    end
    template = File.read("templates/network.erb")
    renderer = ERB.new(template)
    generate = renderer.result(binding)
    myFile = File.open("network/context/common/network", "w")
    myFile.write(generate)
    myFile.close
  end

  desc 'Transfer context files to frontend'
  task :transfer, :roles=>[:subnet] do
    set :user, "#{g5k_user}"
    upload("network/context/common/network","/home/#{g5k_user}/snooze-capistrano/network/context/common/network")
    upload("network/context/common/routes","/home/#{g5k_user}/snooze-capistrano/network/context/common/routes")
  end

  desc 'Generate iso file'
  task :context, :roles=>[:nfs_server] do
    set :user, "root"
    run "mkdir -p /tmp/snooze/images" 
    run "genisoimage -RJ -o /tmp/snooze/images/context.iso /home/#{g5k_user}/snooze-capistrano/network/context"
  end

  desc 'Start VMs'
  task :vms, :roles=>[:nfs_server] do
    set :user, "root"
    run "cd /tmp/snooze/experiments ; ./experiments.sh -c "+ ENV['vcn']+ " "+ENV['vms']
    run "snoozeclient start -vcn " + ENV['vcn']
  end
  
  desc 'fix_permissions'
  task 'fix_permissions', :roles => [:nfs_server] do
    set :user, "root"
    run "chown -R snoozeadmin:snooze /tmp/snooze"
  end
end
