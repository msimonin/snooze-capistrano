include "libvirt"
include "zookeeper"
include "java"


$groupManagerHeartbeatPort = 1000+$idfromhost

class { 
  'snoozenode':
    type                      => "groupmanager",
    controlDataPort           => 5000,
    listenAddress             => $ipaddress,
    multicastAddress          => "225.4.5.6",
    groupManagerHeartbeatPort => $groupManagerHeartbeatPort,
		zookeeperHosts            => ["parapluie-26.rennes.grid5000.fr"],
		virtualMachineSubnet      => ["10.158.4.0/22
"],
}




stage {
  'first':
}

class {
  'apt':
  stage => first
}

Stage['first'] -> Stage['main']

