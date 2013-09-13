class { 'mysql::server': }

mysql::db{ 'keystone':
  user          => 'keystone',
  password      => 'keystone',
  grant         => 'all',
}



class { 'openstack::keystone':
   db_host               => '127.0.0.1',
   db_password           => 'keystone',
   admin_token           => '12345',
   token_format          => 'UUID',
   admin_email           => 'keystone@localhost',
   admin_password        => 'keystone',
   glance_user_password  => 'glance',
   nova_user_password    => 'nova',
   cinder_user_password  => 'cinder',
   neutron_user_password => 'neutron',
   public_address        => '127.0.0.1',
   internal_address      => '127.0.0.1',
   admin_address         => '127.0.0.1'
  }

class openstack::keystone (
  $db_password,
  $admin_token,
  $token_format,
  $admin_email,
  $admin_password,
  $glance_user_password,
  $nova_user_password,
  $cinder_user_password,
  $neutron_user_password,
  $public_address,
  $public_protocol          = 'http',
  $db_host                  = '127.0.0.1',
  $idle_timeout             = '200',
  $db_type                  = 'mysql',
  $db_user                  = 'keystone',
  $db_name                  = 'keystone',
  $admin_tenant             = 'admin',
  $verbose                  = false,
  $debug                    = false,
  $bind_host                = '0.0.0.0',
  $region                   = 'RegionOne',
  $internal_address         = false,
  $admin_address            = false,
  $enabled                  = true
) {

  # Install and configure Keystone
  if $db_type == 'mysql' {
    $sql_conn = "mysql://${db_user}:${db_password}@${db_host}/${db_name}"
  } else {
    fail("db_type ${db_type} is not supported")
  }

  # munging b/c parameters are not
  # set procedurally in Puppet
  if($internal_address) {
    $internal_real = $internal_address
  } else {
    $internal_real = $public_address
  }
  if($admin_address) {
    $admin_real = $admin_address
  } else {
    $admin_real = $internal_real
  }

  class { '::keystone':
    verbose        => $verbose,
    debug          => $debug,
    bind_host      => $bind_host,
    idle_timeout   => $idle_timeout,
    catalog_type   => 'sql',
    admin_token    => $admin_token,
    enabled        => $enabled,
    sql_connection => $sql_conn,
  }

  if ($enabled) {
    # Setup the admin user
    class { 'keystone::roles::admin':
      email        => $admin_email,
      password     => $admin_password,
      admin_tenant => $admin_tenant,
    }

    # Setup the Keystone Identity Endpoint
    class { 'keystone::endpoint':
    }
  }
}

class { 'openstack::glance':
}

class openstack::glance(
  $verbose           = true,
  $keystone_tenant   = 'services',
  $keystone_user     = 'glance',
  $keystone_password = 'glance',
  $db_user           = 'glance',
  $db_password       = 'glance',
  $db_host           = '127.0.0.1',
  $db_name           = 'glance',
  $db_type           = 'mysql',
  $public_address    = '127.0.0.1',
  $admin_address     = '127.0.0.1',
  $internal_address  = '127.0.0.1',
  $region            = 'RegionOne'
){

  if $db_type == 'mysql' {
    $sql_conn = "mysql://${db_user}:${db_password}@${db_host}/${db_name}"
  } else {
    fail("db_type ${db_type} is not supported")
  }

  # setup glance
  class { 'glance::api':
    verbose           => $verbose,
    keystone_tenant   => $keystone_tenant,
    keystone_user     => $keystone_user,
    keystone_password => $keystone_password,
    sql_connection    => $sql_conn,
  }

  class { 'glance::registry':
    verbose           => $verbose,
    keystone_tenant   => $keystone_tenant,
    keystone_user     => $keystone_user,
    keystone_password => $keystone_password,
    sql_connection    => $sql_conn,
  }

  class { 'glance::backend::file': }


  class { 'glance::db::mysql':
    password      => $db_password,
    allowed_hosts => '%',
  }

  class { 'glance::keystone::auth':
    password         => $keystone_password,
    public_address   => $public_address,
    admin_address    => $admin_address,
    internal_address => $internal_address,
    region           => $region,
    }
}


   
