class kadeploy3 {
  
  Package { ensure => "installed" }
  # external dependencies
  $dep = [ "libmysql-ruby1.8", "ruby1.8", "libopenssl-ruby1.8" ]
  package { $dep: }
  
  file { "/opt/kadeploy3":
    ensure => "directory",
  }

  file { "/opt/kadeploy3/kadeploy-common-3.1.5.3.deb":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => "puppet:///modules/kadeploy3/kadeploy-common-3.1.5.3.deb",
    require => File['/opt/kadeploy3'],
  }

  file { "/opt/kadeploy3/kadeploy-client-3.1.5.3.deb":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => "puppet:///modules/kadeploy3/kadeploy-client-3.1.5.3.deb",
    require => File['/opt/kadeploy3'],
  }

  package {'kadeploy-common':
    provider => dpkg,
    source  => "/opt/kadeploy3/kadeploy-common-3.1.5.3.deb",
    require => [File["/opt/kadeploy3/kadeploy-common-3.1.5.3.deb"],
                Package[$dep]],
    before => Exec["apt-fix"]
  }
  exec { 'apt-fix':
    command => "/usr/bin/apt-get -f -y install"
  }

  package {'kadeploy-client':
    provider => dpkg,
    source  => "/opt/kadeploy3/kadeploy-client-3.1.5.3.deb",
    require => [File["/opt/kadeploy3/kadeploy-client-3.1.5.3.deb"],Package["kadeploy-common"]],
    before => Exec["apt-fix"]
  }
  
  #change default depending on site
  file { 'client_conf.yml':
    ensure  => file,
    path    => '/etc/kadeploy3/client_conf.yml',
    owner => 'root',
    group => 'root',
    mode  => '0644',
    require => Package['kadeploy-client'],
    source  => "puppet:///modules/kadeploy3/etc/kadeploy3/client_conf.yml",
   }
}
