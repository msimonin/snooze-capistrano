set :snooze_path, "#{recipes_path}/snooze"
set :snooze_puppet_path, "/home/#{g5k_user}/snooze-puppet"

load "#{snooze_path}/roles.rb"
load "#{snooze_path}/output.rb"

namespace :snooze do
 
  desc 'Install Snooze on nodes'
  task :default do
    prepare::default
    provision::default
    cluster::default
  end

  namespace :prepare do  
    desc 'prepare the nodes'
    task :default do
      puppet
      modules
    end
  
    task :puppet, :roles=>[:all] do
      set :user, 'root'
      run "apt-get update" 
      run "apt-get install -y puppet 2>/dev/null"
      run "apt-get install -y git 2>/dev/null"
    end

    task :modules, :roles => [:frontend] do
      set :user, "#{g5k_user}"
      ls = capture("ls #{snooze_puppet_path} &2>&1")
      if ls!=""
        run "mv #{snooze_puppet_path} #{snooze_puppet_path}"+Time.now.to_i.to_s 
      end
      run "https_proxy='http://proxy:3128' git clone #{snooze_puppet_repo_url} #{snooze_puppet_path}" 
#      upload "/home/msimonin/github/snooze-puppet/", "#{snooze_puppet_path}", :via => :scp, :recursive => true
      run "https_proxy='http://proxy:3128' wget #{snoozenode_deb_url} -O #{snooze_puppet_path}/modules/snoozenode/files/snoozenode.deb 2>1"
      run "https_proxy='http://proxy:3128' wget #{snoozeclient_deb_url} -O #{snooze_puppet_path}/modules/snoozeclient/files/snoozeclient.deb 2>1"
    end
  end

  namespace :provision do
    
    desc 'Provision all the nodes'
    task :default do
      template
      transfer
      apply
    end

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

    task :transfer, :roles => [:frontend] do
      set :user, "#{g5k_user}"
      upload("#{snooze_path}/tmp/bootstrap.pp","#{snooze_puppet_path}/manifests/bootstrap.pp")
      upload("#{snooze_path}/tmp/groupmanager.pp","#{snooze_puppet_path}/manifests/groupmanager.pp")
      upload("#{snooze_path}/tmp/localcontroller.pp","#{snooze_puppet_path}/manifests/localcontroller.pp")
    end


    task :bootstrap do
      template = File.read("#{snooze_path}/templates/snoozenode.erb")
      renderer = ERB.new(template)
      @nodeType             = "bootstrap"
      @zookeeperHosts       = "#{zookeeperHosts}"
      @zookeeperdHosts      = "#{zookeeperdHosts}"
      @externalNotificationHost = "#{rabbitmqServer}"
      @databaseCassandraHosts = "#{cassandraHosts}"
      generate = renderer.result(binding)
      myFile = File.open("#{snooze_path}/tmp/bootstrap.pp", "w")
      myFile.write(generate)
      myFile.close
    end

    task :groupmanager do
      template = File.read("#{snooze_path}/templates/snoozenode.erb")
      renderer = ERB.new(template)
      @nodeType             = "groupmanager"
      @zookeeperHosts       = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first
      @zookeeperdHosts      = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first
      @externalNotificationHost = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first 
      generate = renderer.result(binding)
      myFile = File.open("#{snooze_path}/tmp/groupmanager.pp", "w")
      myFile.write(generate)
      myFile.close
    end


    task :localcontroller do
      template = File.read("#{snooze_path}/templates/snoozenode.erb")
      renderer = ERB.new(template)
      @nodeType             = "localcontroller"
      @zookeeperHosts       = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first
      @zookeeperdHosts      = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first
      @externalNotificationHost = $myxp.get_deployed_nodes("bootstrap", kavlan="#{vlan}").first 
      generate = renderer.result(binding)
      myFile = File.open("#{snooze_path}/tmp/localcontroller.pp", "w")
      myFile.write(generate)
      myFile.close
    end

    task :apply, :roles => [:bootstrap, :groupmanager, :localcontroller] do
      set :user, 'root'
      parallel do |session|
        session.when "in?(:bootstrap)", "puppet apply #{snooze_puppet_path}/manifests/bootstrap.pp --modulepath=#{snooze_puppet_path}/modules/"
        session.when "in?(:groupmanager)", "puppet apply #{snooze_puppet_path}/manifests/groupmanager.pp --modulepath=#{snooze_puppet_path}/modules/"
        session.when "in?(:localcontroller)", "puppet apply #{snooze_puppet_path}/manifests/localcontroller.pp --modulepath=#{snooze_puppet_path}/modules/"
      end
    end 
end

# Cluster configuration
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


  task :bridge_network, :roles => [:localcontroller] do
    set :user, 'root'
    upload "#{snooze_path}/network/interfaces", "/etc/network/interfaces"
    upload "#{snooze_path}/network/configure_network.sh", "/tmp/configure_network.sh"
    run "sh /tmp/configure_network.sh 2>/dev/null"
   end

  task :prepare, :roles=>[:first_bootstrap] do
    set :user, "root"
      ls = capture("ls /tmp/snooze/experiments &2>&1")
      if ls!=""
        run "mv /tmp/snooze/experiments /tmp/snooze/experiments"+Time.now.to_i.to_s 
      end

    run "https_proxy='http://proxy:3128' git clone  #{snooze_experiments_repo_url} /tmp/snooze/experiments" 
  end

  task :copy, :roles=>[:first_bootstrap] do
    set :user, "root"
    run "mkdir -p /tmp/snooze/images"
      ls = capture("ls /tmp/snooze/images/debian-hadoop-context-big.qcow2 &2>&1")
      if ls==""
        run "https_proxy='http://proxy:3128' wget -O /tmp/snooze/images/debian-hadoop-context-big.qcow2 http://public.rennes.grid5000.fr/~msimonin/debian-hadoop-context-big.qcow2 2>1"
      end
  end
  
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
    template = File.read("#{snooze_path}/templates/network.erb")
    renderer = ERB.new(template)
    generate = renderer.result(binding)
    myFile = File.open("#{snooze_path}/network/context/common/network", "w")
    myFile.write(generate)
    myFile.close
  end

  task :context  do
    system "genisoimage -RJ -o #{snooze_path}/tmp/context.iso #{snooze_path}/network/context 2>/dev/null"
  end

  task :transfer, :roles =>[:first_bootstrap] do
     set :user, "root"
     run "mkdir -p /tmp/snooze/images"
     upload "#{snooze_path}/tmp/context.iso", "/tmp/snooze/images/.", :via => :scp
  end
  
  task 'fix_permissions', :roles => [:first_bootstrap] do
    set :user, "root"
    run "chown -R snoozeadmin:snooze /tmp/snooze"
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

  # Dummy vm management ...
  namespace :vms do
    task :start, :roles=>[:first_bootstrap] do
      set :user, "root"
      run "cd /tmp/snooze/experiments ; ./experiments.sh -c "+ ENV['vcn']+ " "+ENV['vms']
      run "snoozeclient start -vcn " + ENV['vcn']
    end

    task :destroy, :roles=>[:first_bootstrap] do
      set :user, "root"
      run "snoozeclient destroy -vcn " + ENV['vcn']
    end
  end

  end
end
