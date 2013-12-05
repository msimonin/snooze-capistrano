require 'bundler/setup'
require 'rubygems'
require 'xp5k'
require 'erb'
load 'config/deploy.rb' 

XP5K::Config.load

$myxp = XP5K::XP.new(:logger => logger)

$myxp.define_job({
  :resources  => ["nodes=7, walltime=#{walltime}"],
  :site      => "#{site}",
  :types      => ["deploy"],
  :name       => "snooze",
  :roles      => [
    XP5K::Role.new({ :name => 'bootstrap', :size => 1 }),
    XP5K::Role.new({ :name => 'groupmanager', :size => 2 }),
    XP5K::Role.new({ :name => 'localcontroller', :size => 3 }),
    XP5K::Role.new({ :name => 'cassandra', :size => 1 }),
#    XP5K::Role.new({ :name => 'dfs', :size => 4 }),
  ],
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  => ["slash_22=1, walltime=#{walltime}"],
  :site       => "#{site}",
  :name       => "subnet",
  :command    => "sleep 86400"
})

$myxp.define_deployment({
  :environment    => "wheezy-x64-nfs",
  :site           => "#{site}",
  :jobs           => %w{},
  :roles          => %w{ bootstrap groupmanager localcontroller cassandra},
  :retry          => true,
  :key            => File.read("#{ssh_public}"), 
})

load "config/deploy/xp5k/xp5k_common_tasks.rb"
load "config/deploy/xp5k/xp5k_common_roles.rb"
