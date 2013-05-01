class { 'rabbitmq::server':
}

rabbitmq_user { 'snooze':
  password => 'snooze',
  provider => 'rabbitmqctl',
}

rabbitmq_vhost { 'snooze-vhost':
  ensure => present,
  provider => 'rabbitmqctl',
}

rabbitmq_user_permissions { 'snooze@snooze-vhost':
  configure_permission => '.*',
  read_permission      => '.*',
  write_permission     => '.*',
  provider => 'rabbitmqctl',
}

