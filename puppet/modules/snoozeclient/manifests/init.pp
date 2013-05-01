class snoozeclient(){

  file { "/opt/snoozeclient":
    ensure => "directory",
	}

	file { "/opt/snoozenode/snoozeclient.deb":
	  ensure  => present,
	  owner   => root,
	  group   => root,
	  mode    => 644,
	  source  => "puppet:///modules/snoozeclient/snoozeclient.deb",
    require => File['/opt/snoozeclient'],
	}

	package { 'snoozeclient':
	  provider => dpkg,
	  source  => "/opt/snoozenode/snoozeclient.deb",
	  require => [File["/opt/snoozenode/snoozeclient.deb"],Package["openjdk-6-jre"]],
  }

}
