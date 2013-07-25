 include "snoozeclient"

$groupManagerHeartbeatPort = 1000+$idfromhost

class { 
  'snoozenode':
    type                      => "bootstrap",
    controlDataPort           => 5000,
    listenAddress             => $ipaddress,
    multicastAddress          => "225.4.5.16",
    groupManagerHeartbeatPort => $groupManagerHeartbeatPort,
    zookeeperHosts            => ["parapluie-23.rennes.grid5000.fr"],
    virtualMachineSubnet      => ["10.158.120.0/22", "10.158.88.0/22", "10.158.116.0/22", "10.158.108.0/22", "10.158.112.0/22", "10.158.92.0/22", "10.158.72.0/22", "10.158.96.0/22", "10.158.68.0/22", "10.158.100.0/22", "10.158.76.0/22", "10.158.80.0/22", "10.158.104.0/22", "10.158.84.0/22", "10.158.64.0/22", "10.158.124.0/22"],
    externalNotificationHost  => "parapluie-23.rennes.grid5000.fr",
    databaseType              => "memory",
    databaseCassandraHosts    => ["paradent-14.rennes.grid5000.fr", "paradent-15.rennes.grid5000.fr", "paradent-16.rennes.grid5000.fr", "paradent-17.rennes.grid5000.fr"]
}




  class { 
	    'zookeeper::zookeeperd': 
       zookeeperHosts            => ["parapluie-23.rennes.grid5000.fr"],
  }



