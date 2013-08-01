class { 'dfs':
   dfstype => "glusterfs",
   dfsmaster => "parapluie-2.rennes.grid5000.fr",
   volume => "/G5K_Gluster",
   local => "/tmp/snooze"
}
