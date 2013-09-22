role :bootstrap do
  $myxp.get_deployed_nodes('bootstrap').first
end

role :first_bootstrap do
  $myxp.get_deployed_nodes('bootstrap').first
end

role :groupmanager do
  $myxp.get_deployed_nodes('groupmanager')
end

role :localcontroller do
  $myxp.get_deployed_nodes('localcontroller')
end

role :all do
  $myxp.get_deployed_nodes('bootstrap') + $myxp.get_deployed_nodes('groupmanager') +  $myxp.get_deployed_nodes('localcontroller')  
end
=begin
role :frontend do
  "rennes"
end

role :subnet do
  "rennes"
end
=end

def zookeeperHosts
  $myxp.get_deployed_nodes('bootstrap').first
end

def zookeeperdHosts
  $myxp.get_deployed_nodes('bootstrap').first
end

def rabbitmqServer
  $myxp.get_deployed_nodes('bootstrap').first
end

def cassandraHosts
  $myxp.get_deployed_nodes('cassandra')
end

