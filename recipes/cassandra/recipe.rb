set :cassandra_path, "#{recipes_path}/cassandra"

load "#{cassandra_path}/roles.rb"
load "#{cassandra_path}/output.rb"

namespace :cassandra do

  desc 'Deploy Cassandra on nodes'
  task :default do
    puppet
    generate
    modules::install
    transfer
    apply
    schema::default
    opscenter::default
  end

  task :generate do
    template = File.read("#{cassandra_path}/templates/cassandra.erb")
    renderer = ERB.new(template)
    @cassandra_name = "cassandra_cluster"
    @cassandra_seeds = "#{seeds}"
    generate = renderer.result(binding)
    myFile = File.open("#{cassandra_path}/tmp/cassandra.pp", "w")
    myFile.write(generate)
    myFile.close
  end

  task :puppet, :roles => [:cassandra] do
    set :user, "root"
    run "apt-get install -y puppet 2>/dev/null"
  end

  namespace :modules do
    task :install, :roles => [:cassandra] do
      set :user, "root"
      run "https_proxy='http://proxy:3128' http_proxy='http://proxy:3128' puppet module install gini/cassandra"
   end

    task :uninstall, :roles => [:cassandra] do
      set :user, "root"
      run "https_proxy='http://proxy:3128' http_proxy='http://proxy:3128' puppet module uninstall gini/cassandra"
   end

  end

  task :transfer, :roles => [:cassandra] do
    set :user, "root"
    upload("#{cassandra_path}/tmp/cassandra.pp","/tmp/cassandra.pp", :via => :scp)  
  end

  task :apply, :roles => [:cassandra] do
    set :user, "root"
    run "http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' FACTER_osfamily='Debian' puppet apply /tmp/cassandra.pp -d "
  end

  namespace :schema do
    
    desc 'Install the database schema'
    task :default do
      transfer
      # Waiting for the system to be ready 
      system("sleep 20")
      apply
    end
    
    task :transfer, :roles=> [:cassandra_first] do
      set :user, "root"
      upload "#{cassandra_path}/schema/schemaup.cas", "/tmp/schemaup.cas"
      upload "#{cassandra_path}/schema/schemadown.cas", "/tmp/schemadown.cas"
    end

    task :apply, :roles=> [:cassandra_first] do
      run "cassandra-cli -f /tmp/schemaup.cas"
    end

    task :remove, :roles => [:cassandra_first] do
      run "cassandra-cli -f /tmp/schemadown.cas"
    end

  end
 
  # hack to install opscenter on debian
  # require openssl 0.9.8 but removed from wheezy
  # Only work on debian
  namespace :opscenter do
    desc 'Install the opscenter'
    task :default do
      package
      install
    end

    # source.list updated with cassandra
    task :package, :roles => [:cassandra_first] do
      set :user, "root"
      run "http_proxy='http://proxy:3128' wget http://ftp.fr.debian.org/debian/pool/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb -O /tmp/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb 2>1"
    end

    task :install, :roles => [:cassandra_first] do
      set :user, "root"
      run "dpkg -i /tmp/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb 2>1"
      run "apt-get install -y opscenter-free 2>1"
    end

  end

end

