set :snooze_webinterface_path, "#{recipes_path}/snooze_webinterface"
#set :webinterface_url, "/home/msimonin/github/snoozeweb/"
set :webinterface_url, "https://github.com/msimonin/snoozeweb.git"
set :webinterface_directory, "/tmp/snoozeweb"

load "#{snooze_webinterface_path}/roles.rb"
load "#{snooze_webinterface_path}/output.rb"

namespace :snooze_webinterface do

  desc 'Deploy snooze web interface'
  task :default do
    install::default  
    launch
    summary
  end

  namespace :install do
    desc 'Install the needed stuffs'
    task :default do
      packages
      files
      bundle
      gems
    end
    
    task :packages   , :roles => [:snooze_webinterface] do
      set :user, "root"
      run "apt-get update"
      run "apt-get -y install git"
    end

    task :files, :roles => [:snooze_webinterface] do
      set :user, "root"
      run "http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' git clone #{webinterface_url} #{webinterface_directory}"
      #upload "#{webinterface_url}", "#{webinterface_directory}", :via => :scp, :recursive => true
    end

    task :bundle, :roles => [:snooze_webinterface] do
      set :user, "root"
      run "http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' gem install bundler"
    end

    task :gems, :roles => [:snooze_webinterface] do
      set :user, "root"
      run "cd #{webinterface_directory} ; http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' bundle install"
    end
  end

  task :launch, :roles => [:snooze_webinterface] do
    set :user, "root"
    run "cd #{webinterface_directory} ; nohup rackup -p 80 > /tmp/webinterface 2>&1 & "
  end

  task :summary do
    webui = find_servers :roles => [:snooze_webinterface]
    host = webui.first.host.split('.').insert(2,'proxy-http').join('.')
    puts <<-EOF
      +------------------ Snooze Web Interface -------------+
                                                          
       Connect to :                                      
                                                           
       https://#{host}
      +-----------------------------------------------------+
    EOF

  end


end

