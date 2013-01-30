class java{
   package { 'openjdk-6-jre':
     ensure => installed,
     require => Exec['apt-get_update']
   }
}
