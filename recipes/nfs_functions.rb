#
# Fill below with your specific parameters
#
def host
  $myxp.get_assigned_nodes('bootstrap',kavlan="#{vlan}").first
end

def nfs_shared
  "/tmp/snooze27"
end

def nfs_local
  "/tmp/snooze27"
end

def uid
  "root"
end

def gid
  "root"
end

def nfs_options
  "rw,nfsvers=3,hard,intr,async,noatime,nodev,nosuid,auto,rsize=32768,wsize=32768" 
end

role :nfs_server do
  $myxp.get_assigned_nodes('bootstrap', kavlan="#{vlan}").first
end

role :nfs_slave do 
  $myxp.get_assigned_nodes('groupmanager', kavlan="#{vlan}")
end

