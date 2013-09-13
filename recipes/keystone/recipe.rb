set :keystone_path, "#{recipes_path}/keystone"

load "#{keystone_path}/roles.rb"
load "#{keystone_path}/output.rb"

namespace :keystone do

  desc 'Deploy keystone on nodes'
  task :default do
    puppet
    generate
    modules::install
    transfer
    apply
  end


  task :generate do
    template = File.read("#{keystone_path}/templates/keystone.erb")
    renderer = ERB.new(template)
    myFile = File.open("#{keystone_path}/tmp/keystone.pp", "w")
    generate = renderer.result(binding)
    myFile.write(generate)
    myFile.close
  end

  task :puppet, :roles => [:keystone] do
    set :user, "root"
    run "apt-get install -y puppet 2>/dev/null"
  end

  namespace :modules do
    task :install, :roles => [:keystone] do
      set :user, "root"
      run "https_proxy='http://proxy:3128' http_proxy='http://proxy:3128' puppet module install puppetlabs/keystone"
      run "https_proxy='http://proxy:3128' http_proxy='http://proxy:3128' puppet module install puppetlabs/glance"
   end

    task :uninstall, :roles => [:keystone] do
      set :user, "root"
      run "https_proxy='http://proxy:3128' http_proxy='http://proxy:3128' puppet module uninstall puppetlabs/glance "
      run "https_proxy='http://proxy:3128' http_proxy='http://proxy:3128' puppet module uninstall puppetlabs/keystone "
   end

  end


  task :transfer, :roles => [:keystone] do
    set :user, "root"
    upload("#{keystone_path}/tmp/keystone.pp","/tmp/keystone.pp", :via => :scp)  
  end


  task :apply, :roles => [:keystone] do
    set :user, "root"
    run "http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' SERVICE_TOKEN='12345' puppet apply /tmp/keystone.pp "
  end

end

