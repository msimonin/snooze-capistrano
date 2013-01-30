class nfs ($nfshost="",$shared="", $local=""){
  package { 'nfs-common':
    ensure => installed,
  }

  mount { "$local":
    device  => "$nfshost:$shared",
    fstype  => "nfs",
    ensure  => "mounted",
    options => "defaults",
    atboot  => true,
    require => [Package['nfs-common'],File["$local"]]
  }

  file { $local:
    ensure => directory
  }
}
