def dfs_master
 $myxp.get_assigned_nodes('bootstrap', kavlan="#{vlan}").first
end

def dfs_type()
  "glusterfs"
end

def dfs_volume()
  "/G5K_Gluster"
end

def data_nodes()
  $myxp.get_assigned_nodes('groupmanager', kavlan="#{vlan}")
end

def client_nodes()
  $myxp.get_assigned_nodes('localcontroller', kavlan="#{vlan}")
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
