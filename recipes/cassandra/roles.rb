# cassandra nodes
role :cassandra do
  $myxp.get_deployed_nodes('cassandra', kavlan="#{vlan}")
end

# cassandra first node (opscenter installation)
role :cassandra_first do
  $myxp.get_deployed_nodes('cassandra', kavlan="#{vlan}").first
end

# seeds
def seeds
  $myxp.get_deployed_nodes('cassandra', kavlan="#{vlan}").slice(0..4)
end
