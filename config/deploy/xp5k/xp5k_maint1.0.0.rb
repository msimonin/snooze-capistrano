require 'bundler/setup'
require 'rubygems'
require 'xp5k'
require 'erb'
load 'config/deploy.rb' 

XP5K::Config.load

$myxp = XP5K::XP.new(:logger => logger)

$myxp.define_job({
  :resources  => ["nodes=1, walltime=#{walltime}"],
  :site       => "rennes",
  :types      => ["deploy"],
  :name       => "bootstrap",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  =>["nodes=2, walltime=#{walltime}"],
  :site       => "rennes",
  :types      => ["deploy"],
  :name       => "groupmanager",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources  => ["nodes=3, walltime=#{walltime}"],
  :site       => "rennes",
  :types      => ["deploy"],
  :name       => "localcontroller",
  :command    => "sleep 86400"
})

$myxp.define_job({
  :resources => ["#{subnet}=1, walltime=#{walltime}"],
  :site      => "rennes",
  :name      => "subnet",
  :command   => "sleep 86400"
})

$myxp.define_deployment({
  :environment => "wheezy-x64-nfs",
  :site        => "rennes",
  :jobs        => %w{bootstrap groupmanager localcontroller},
  :key         => File.read("#{ssh_public}"),
})

load "config/deploy/xp5k/xp5k_common_tasks.rb"
load "config/deploy/xp5k/xp5k_common_roles.rb"
