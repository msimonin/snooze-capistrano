role :bootstrap do
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end

role :first_bootstrap do
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end

role :groupmanager do
  $myxp.get_deployed_nodes('groupmanager', kavlan="#{vlan}")
end

role :localcontroller do
  $myxp.get_deployed_nodes('localcontroller', kavlan="#{vlan}")
end

role :all do
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}") + $myxp.get_deployed_nodes('groupmanager', kavlan="#{vlan}") +  $myxp.get_deployed_nodes('localcontroller', kavlan="#{vlan}")  
end

role :frontend do
  $myxp.get_sites_with_jobs()
end

role :subnet do
  $myxp.get_sites_with_job('subnet')
end

def zookeeperHosts
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end

def zookeeperdHosts
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end

def rabbitmqServer
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end

def cassandraHosts
  $myxp.get_deployed_nodes('cassandra', kavlan="#{vlan}")
end

