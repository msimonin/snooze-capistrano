class nfs ($nfshost="",$shared="", $local=""){
  package { 'nfs-common':
    ensure => installed,
  }

  mount { "$local":
    device  => "$nfshost:$shared",
    fstype  => "nfs",
    ensure  => "mounted",
    options => "rw,nfsvers=3,hard,intr,async,noatime,nodev,nosuid,auto,rsize=32768,wsize=32768",
    atboot  => true,
    require => [Package['nfs-common'],File["$local"]]
  }

  file { $local:
    ensure => directory
  }
}
