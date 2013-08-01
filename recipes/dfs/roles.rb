def dfs_master
  $myxp.get_deployed_nodes('dfs_data', kavlan="#{vlan}").first
end

def dfs_type()
  "glusterfs"
end

def dfs_volume()
  "/G5K_Gluster"
end

def data_nodes()
  $myxp.get_deployed_nodes('dfs_data', kavlan="#{vlan}")
end

def client_nodes()
  $myxp.get_deployed_nodes('localcontroller', kavlan="#{vlan}")  +  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}")
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
