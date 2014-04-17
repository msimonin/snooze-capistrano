require 'bundler/setup'
require 'rubygems'
require 'xp5k'
require 'erb'
load 'config/deploy.rb' 

XP5K::Config.load

$myxp = XP5K::XP.new(:logger => logger)

$myxp.define_job({
  :resources  => ["{virtual!='none'}nodes=2, walltime=#{walltime}"],
#  :resources  => ["{cluster='taurus'}nodes=5, walltime=#{walltime}"],
  :site      => "#{site}",
  :types      => ["deploy"],
  :name       => "[xp5k]snooze_compute",
  :roles      => [
    XP5K::Role.new({ :name => 'localcontroller', :size => 2 }),
  ],
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  => ["nodes=5, walltime=#{walltime}"],
  :site      => "#{site}",
  :types      => ["deploy"],
  :name       => "[xp5k]snooze_service",
  :roles      => [
    XP5K::Role.new({ :name => 'bootstrap', :size => 1 }),
    XP5K::Role.new({ :name => 'groupmanager', :size => 3 }),
    XP5K::Role.new({ :name => 'cassandra', :size => 1 }),
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
