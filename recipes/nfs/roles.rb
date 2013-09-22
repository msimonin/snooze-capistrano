role :nfs_server do
  $myxp.get_deployed_nodes('bootstrap').first
end

role :nfs_slave do
  $myxp.get_deployed_nodes('localcontroller')
end

def host
  $myxp.get_deployed_nodes('bootstrap').first
end

def nfs_shared
  "/tmp/snooze"
end

def nfs_local
  "/tmp/snooze"
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
