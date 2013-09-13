class nfs ( $nfshost="",
            $shared="/tmp/shared",
            $local="/tmp/local",
            $options="defaults" 
             ){

  package { 'nfs-common':
    ensure => installed,
  }

  mount { "$local":
    device  => "$nfshost:$shared",
    fstype  => "nfs",
    ensure  => "mounted",
    options => "$options",
    atboot  => true,
    require => [Package['nfs-common'],File["$local"]]
  }

  file { $local:
    ensure => directory
  }

  file_line { "exit0":
    ensure => absent,
    line => "exit 0",
    path => "/etc/rc.local"
  }

  file_line { "atboot":
    ensure => present,
    line   => "/bin/mkdir -p ${local}; /bin/mount -a; exit 0",
    path   => "/etc/rc.local"
  }

  File_line["exit0"] -> File_line["atboot"]

}
