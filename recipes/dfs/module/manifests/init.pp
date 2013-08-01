class dfs ( $dfstype = "glusterfs",
            $dfsmaster = "localhost",
            $volume = "/G5K_gluster",
            $local = "/tmp/local",
                                                 ){

  package { 'glusterfs':
    ensure => installed,
  }

  mount { "$local":
    device => "$dfsmaster:$volume",
    fstype => "$dfstype",
    ensure => "mounted",
    atboot => true,
    require => [Package['glusterfs'],File["$local"]]
  }

  file { $local:
    ensure => directory
  }
}
