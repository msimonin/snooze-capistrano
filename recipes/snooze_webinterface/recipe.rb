set :snooze_webinterface_path, "#{recipes_path}/snooze_webinterface"
set :jruby_version, "1.7.4"
set :jruby_url, "http://public.rennes.grid5000.fr/~msimonin/jruby-bin-#{jruby_version}.tar.gz"
set :webinterface_url, "/home/msimonin/ruby/sinatra/sinatra-bootstrap/"
set :webinterface_directory, "/tmp/sinatra"

load "#{snooze_webinterface_path}/roles.rb"
load "#{snooze_webinterface_path}/output.rb"

namespace :snooze_webinterface do

  desc 'Deploy snooze web interface'
  task :default do
    jruby::install
    webinterface::default
  end


  task :generate do
    template = File.read("#{snooze_webinterface_path}/templates/snooze_webinterface.erb")
    renderer = ERB.new(template)
    myFile = File.open("#{snooze_webinterface_path}/tmp/snooze_webinterface.pp", "w")
    generate = renderer.result(binding)
    myFile.write(generate)
    myFile.close
  end

  namespace :jruby do
    task :install, :roles => [:snooze_webinterface] do
      set :user, "root"
      run "wget #{jruby_url} -O /opt/jruby-#{jruby_version}.tar.gz"
      run "cd /opt ; tar -xvzf jruby-#{jruby_version}.tar.gz"
      run "ln -s /opt/jruby-#{jruby_version}/bin/jruby /usr/bin/jruby"
      run "http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' jruby -S gem install bundler"
   end

  end

  namespace :webinterface do
    
    desc 'Install the web interface'
    task :default do
      install::default
      launch
    end

    namespace :install do
      
      task :default do
        files
        gems
      end
      
      task :files, :roles => [:snooze_webinterface] do
        set :user, "root"
        upload "#{webinterface_url}", "#{webinterface_directory}", :via => :scp, :recursive=>true 
      end

      task :gems, :roles => [:snooze_webinterface] do
        set :user, "root"
        run "cd #{webinterface_directory} ; http_proxy='http://proxy:3128' https_proxy='http://proxy:3128' jruby -S bundle install "
      end

    end



    task :launch, :roles => [:snooze_webinterface] do
      set :user, "root"
      run "nohup jruby #{webinterface_directory}/app.rb >> /tmp/webinterface &"
    end
  end
 

end

