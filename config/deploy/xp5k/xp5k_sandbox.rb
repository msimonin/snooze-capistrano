require 'bundler/setup'
require 'rubygems'
require 'xp5k'
require 'erb'
load 'config/deploy.rb' 

XP5K::Config.load

$myxp = XP5K::XP.new(:logger => logger)

$myxp.define_job({
  :resources  => ["nodes=#{ENV["nodes"] || 1}, walltime=#{walltime}"],
  :site       => "sophia",
  :retry      => true,
  :goal       => "100%",
  :types      => ["deploy"],
  :name       => ENV["recipe"] || "sandbox" , 
  :command    => "sleep 86400"
})

$myxp.define_deployment({
  :site           => "sophia",
  :environment    => "wheezy-x64-nfs",
  :jobs           => [ENV["recipe"] || "sandbox" ],
  :key            => File.read("#{ssh_public}"), 
})

load "config/deploy/xp5k/xp5k_common_tasks.rb"
