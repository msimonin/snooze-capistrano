set :openvswitch_path, "#{recipes_path}/openvswitch"

load "#{openvswitch_path}/roles.rb"
load "#{openvswitch_path}/output.rb"

namespace :openvswitch do

  desc 'Deploy openvswitch on nodes'
  task :default do
    openvswitch
    build
    bridge
    vm::default
  end


  task :openvswitch, :roles => [:openvswitch] do
    set :user, "root"
    run "apt-get update 2>/dev/null"
    run "apt-get install -y openvswitch-brcompat openvswitch-datapath-source 2>/dev/null"
    run "apt-get install -y  libvirt-bin kvm qemu-utils 2>/dev/null"
  end

  task :build, :roles => [:openvswitch] do
    set :user, "root"
    run "module-assistant auto-install openvswitch-datapath"
  end

  task :bridge, :roles => [:openvswitch] do
    set :user, "root"
#    run "killall dhclient 2>/dev/null"
    run "service openvswitch-switch start"
    run "ovs-vsctl add-br br0"
    run "ovs-vsctl add-port br0 eth0"
    run "ifconfig eth0 0.0.0.0; dhclient br0"
  end

  namespace :vm do
  
    desc 'Prepare vm disks images + templates' 
    task :default do
      disk_images
      templates
      transfer
    end

    task :disk_images, :roles => [:openvswitch] do
      set :user, "root"
      run "cp /grid5000/images/KVM/wheezy-x64-base.qcow2 /tmp/"
      10.times{ |i| 
        run "qemu-img create -b /tmp/wheezy-x64-base.qcow2 -f qcow2 /tmp/wheezy-#{i}.qcow2"
      }
    end

    task :templates do
      10.times{ |i|
        template = File.read("#{openvswitch_path}/templates/vm-template.xml.erb")
        renderer = ERB.new(template)
        @vmid = i
        generate = renderer.result(binding)
        myFile = File.open("#{openvswitch_path}/tmp/wheezy-#{i}.xml", "w")
        myFile.write(generate)
        myFile.close
      }
    end

    task :transfer do
      10.times{ |i| 
        upload("#{openvswitch_path}/tmp/wheezy-#{i}.xml","/tmp/wheezy-#{i}.xml")
      }
    end

  end


end

