def dfs_master
  $myxp.get_deployed_nodes('dfs_data').first
end

def dfs_type()
  "glusterfs"
end

def dfs_volume()
  "/G5K_Gluster"
end

def data_nodes()
  $myxp.get_deployed_nodes('dfs_data')
end

def client_nodes()
  $myxp.get_deployed_nodes('localcontroller')  +  $myxp.get_deployed_nodes('bootstrap')
end

def dfs_local()
  "/tmp/snooze"
end

role :dfsfrontend do
  %w( rennes )
end

role :dfs_client do
  client_nodes
end

role :dfs_data do
  data_nodes
end
