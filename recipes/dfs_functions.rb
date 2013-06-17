def dfs_master
 $myxp.get_deployed_nodes('dfs', kavlan="#{vlan}").first
end

def dfs_type()
  "glusterfs"
end

def dfs_volume()
  "/G5K_Gluster"
end

def data_nodes()
  $myxp.get_deployed_nodes('dfs', kavlan="#{vlan}")
end

def client_nodes()
  $myxp.get_deployed_nodes('localcontroller', kavlan="#{vlan}") + $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}")
end

def dfs_local()
  "/tmp/snooze"
end


# dfs5k can be called from any frontend 
role :singlefrontend do
  %w( reims )
end

role :client do
  client_nodes
end

