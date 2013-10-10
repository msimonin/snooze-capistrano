set :rabbitmq_path, "#{recipes_path}/rabbitmq"

load "#{rabbitmq_path}/roles.rb"
load "#{rabbitmq_path}/output.rb"

namespace :rabbitmq do

  desc 'Deploy RabbitMQ on nodes'
  task :default do
    puppet
    generate
    modules::install
    transfer
    apply
    web_stomp_plugin
  end


  task :generate do
    template = File.read("#{rabbitmq_path}/templates/rabbitmq.erb")
    renderer = ERB.new(template)
    myFile = File.open("#{rabbitmq_path}/tmp/rabbitmq.pp", "w")
    generate = renderer.result(binding)
    myFile.write(generate)
    myFile.close
  end

  task :puppet, :roles => [:rabbitmq] do
    set :user, "root"
    run "apt-get update 2>/dev/null"
    run "apt-get install -y puppet 2>/dev/null"
  end

  namespace :modules do
    task :install, :roles => [:rabbitmq] do
      set :user, "root"
      run "https_proxy='http://proxy:3128' http_proxy='http://proxy:3128' puppet module install puppetlabs/rabbitmq --version 2.1.0"
   end

    task :uninstall, :roles => [:rabbitmq] do
      set :user, "root"
      run "https_proxy='http://proxy:3128' http_proxy='http://proxy:3128' puppet module uninstall puppetlabs/rabbitmq "
   end

  end


  task :transfer, :roles => [:rabbitmq] do
    set :user, "root"
    upload("#{rabbitmq_path}/tmp/rabbitmq.pp","/tmp/rabbitmq.pp", :via => :scp)  
  end


  task :apply, :roles => [:rabbitmq] do
    set :user, "root"
    run "http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' puppet apply /tmp/rabbitmq.pp "
  end

  task :web_stomp_plugin, :roles =>[:rabbitmq] do
    set :user, "root"
    run "wget http://public.rennes.grid5000.fr/~msimonin/web_stomp_plugin/web_stomp_plugin_2.8.2.tar.gz 2>1"
    run "tar -xvzf web_stomp_plugin_2.8.2.tar.gz"
    run "cp web_stomp_plugin_2.8.2/* /usr/lib/rabbitmq/lib/rabbitmq_server-2.8.4/plugins/."
    run "rabbitmq-plugins enable rabbitmq_web_stomp"
    run "rabbitmq-plugins enable rabbitmq_web_stomp_examples"
    run "service rabbitmq-server restart"
  end

end

