require 'bundler/setup'
require 'rubygems'
require 'xp5k'
require 'erb'
load 'config/deploy.rb' 

XP5K::Config.load

$myxp = XP5K::XP.new(:logger => logger)

$myxp.define_job({
  :resources  => ["nodes=2, walltime=#{walltime}"],
  :site      => "#{site}",
  :types      => ["deploy"],
  :name       => "[xp5k]serf",
  :roles      => [
    XP5K::Role.new({ :name => 'serf', :size => 1 }),
    XP5K::Role.new({ :name => 'bootstrap', :size => 1 }),
  ],
  :command    => "sleep 86400"
})

$myxp.define_deployment({
  :environment    => "wheezy-x64-nfs",
  :site           => "#{site}",
  :jobs           => %w{},
  :roles          => %w{ bootstrap serf},
  :retry          => true,
  :key            => File.read("#{ssh_public}"), 
})

load "config/deploy/xp5k/xp5k_common_tasks.rb"
load "config/deploy/xp5k/xp5k_common_roles.rb"
