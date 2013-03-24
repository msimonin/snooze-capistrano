class snoozenode::nfs (){

  file { '/tmp/snooze/':
    ensure	=> directory,
    owner	=> "snoozeadmin",
    group	=> "snooze",
    require	=> [User["snoozeadmin"],Group["snooze"]]
  }

  file { '/tmp/snooze/images':
    ensure	=> directory,
    owner	=> "snoozeadmin",
    group	=> "snooze",
    require	=> [User["snoozeadmin"],Group["snooze"]]
  }

  file { '/tmp/snooze/templates':
    ensure	=> directory,
    owner	=> "snoozeadmin",
    group	=> "snooze",
    require	=> [User["snoozeadmin"],Group["snooze"]]
  }
}
