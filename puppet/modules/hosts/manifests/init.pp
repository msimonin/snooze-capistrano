class hosts ($hostname="generic"){

	host{
	  'host':
		ensure => present,
		ip 		 => '127.0.1.1',
		name   => $hostname
	}

	exec {
		'reconfigure hostname':
			path => '/usr/sbin:/usr/bin:/sbin:/bin',
			command => '/etc/init.d/hostname restart',
			refreshonly => true;
	}
  
		file {
			'/etc/hostname':
				ensure => file,
				mode => 644, owner => root, group => root,
				content => $hostname,
				notify => Exec['reconfigure hostname'];
	  }

}
