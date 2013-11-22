class nfs::server ($shared="", $uid="root", $gid="root") {
  require 'stdlib'

  package { 'nfs-kernel-server':
    ensure => installed,
  }

  service { 'nfs-kernel-server':
    name      => nfs-kernel-server,
    ensure    => running,
    enable    => true,
    require   => Package['nfs-kernel-server']
  }

  file {
    "$shared":
    ensure => directory,
    owner => $uid,
    group => $gid,
  }


  file_line { "shared_line":
    line => "$shared *(rw,async,no_subtree_check,no_root_squash)",
    path => '/etc/exports',
    notify => Service['nfs-kernel-server'],
  }

} 
