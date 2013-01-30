class libvirt{

   package { 'libvirt-bin':
     ensure => installed,
   }

   package { 'libvirt-dev':
     ensure => installed,
   }

   package { 'qemu-kvm':
     ensure => installed,
   }
   

   file { 'libvirtd.conf':
        path    => '/etc/libvirt/libvirtd.conf',
        ensure  => file,
        owner   => "root",
        group   => "root",
        mode    => '0644',
        require => Package['libvirt-bin'],
        source  => "puppet:///modules/libvirt/etc/libvirtd.conf",
      }

  file { 'libvirt-bin':
    path   => '/etc/default/libvirt-bin',
    ensure  => file,
    owner   => "root",
    group   => "root",
    mode  => '0644',
    require => Package['libvirt-bin'],
    source  => "puppet:///modules/libvirt/etc/default/libvirt-bin",
  }
 
   service { 'libvirt-bin':
     name      => libvirt-bin,
     ensure    => running,
     enable    => true,
     subscribe => [File['libvirtd.conf'],File['libvirt-bin']]
  }

  exec {'refresh-libvirt':
    command => "/etc/init.d/libvirt-bin restart",
    subscribe => [File['libvirtd.conf'],File['libvirt-bin']],
    require => Package['libvirt-bin'],
  }

}
