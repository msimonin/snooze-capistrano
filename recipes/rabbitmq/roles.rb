role :rabbitmq do
  $myxp.get_deployed_nodes('bootstrap').first
end
