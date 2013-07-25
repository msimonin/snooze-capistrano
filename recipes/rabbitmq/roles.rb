role :rabbitmq do
  $myxp.get_deployed_nodes('bootstrap', kavlan="#{vlan}").first
end
