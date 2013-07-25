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
}
