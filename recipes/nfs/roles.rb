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
  if "#{branch}" == "experimental"
    "/tmp/snooze/images"
  else
    "/tmp/snooze"
  end
end

def nfs_local
  if "#{branch}" == "experimental"
    "/var/lib/libvirt/snoozeimages"
  else 
    "/tmp/snooze"
  end
end

def uid
  "snoozeadmin"
end

def gid
  "snooze"
end


def nfs_options
  "rw,nfsvers=3,hard,intr,async,noatime,nodev,nosuid,auto,rsize=32768,wsize=32768"
end
