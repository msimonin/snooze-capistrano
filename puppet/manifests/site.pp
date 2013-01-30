
node default {

  Class['libvirt'] -> Class['snoozesetup']

  include apt
  include libvirt
  include nfs
  include java 
  include zookeeper
  include kadeploy3
  include snoozesetup
}
