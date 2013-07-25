require 'bundler/setup'
require 'rubygems'
require 'xp5k'
require 'erb'
load 'config/deploy.rb' 

XP5K::Config.load

$myxp = XP5K::XPM.new(:logger => logger)

$myxp.define_job({
  :resources  => ["nodes=1, walltime=#{walltime}"],
  :sites      => %w( rennes ),
  :types      => ["deploy"],
  :name       => "bootstrap",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  =>["nodes=2, walltime=#{walltime}"],
  :sites      => %w( rennes ) ,
  :types      => ["deploy"],
  :name       => "groupmanager",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  => ["nodes=3, walltime=#{walltime}"],
  :sites       => %w( rennes ),
  :types      => ["deploy"],
  :name       => "localcontroller",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  => ["nodes=4, walltime=#{walltime}"],
  :sites       => %w( rennes ),
  :types      => ["deploy"],
  :name       => "cassandra",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  => ["#{subnet}=1, walltime=#{walltime}"],
  :sites       => %w( rennes ),
  :name       => "subnet",
  :command    => "sleep 86400"
})

$myxp.define_deployment({
  :environment    => "wheezy-x64-nfs",
  :jobs           => %w{bootstrap groupmanager localcontroller cassandra},
  :key            => File.read("#{ssh_public}"), 
})

task :xp5k do
  puts "  XP5K launched (submission and deployment)"
end


desc 'Submit jobs'
task :submit do
  $myxp.submit
end

desc 'Deploy with Kadeploy'
task :deploy  do
  $myxp.deploy
end

desc 'Remove all running jobs'
task :clean do
logger.debug "Clean all Grid'5000 running jobs..."
  $myxp.clean
end

after "xp5k", "submit", "deploy"
