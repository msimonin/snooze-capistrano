class apt{
  
   
  exec { 'apt-get_update':
    command => "/usr/bin/apt-get update",
  }

  file {
    '/etc/apt/sources.list.d/testing.list' :
    ensure => file,
    source => "puppet:///modules/apt/etc/apt/sources.list.d/testing.list",
  } 
 
  file {
    '/etc/apt/preferences.d/testing' :
    ensure => file,
    source => "puppet:///modules/apt/etc/apt/preferences.d/testing",
  } 
    File['/etc/apt/sources.list.d/testing.list'] -> File['/etc/apt/preferences.d/testing'] -> Exec['apt-get_update'] 
}
