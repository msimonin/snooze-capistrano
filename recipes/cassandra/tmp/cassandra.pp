class { 'cassandra':
  cluster_name  => "cassandra_cluster",
  seeds         => ["paradent-14.rennes.grid5000.fr", "paradent-15.rennes.grid5000.fr", "paradent-16.rennes.grid5000.fr", "paradent-17.rennes.grid5000.fr"],
  repo_pin      => false
}
