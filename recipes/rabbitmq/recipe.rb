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

end

