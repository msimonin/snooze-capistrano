role :keystone do
  $myxp.get_deployed_nodes('keystone', kavlan="#{vlan}").first
end
