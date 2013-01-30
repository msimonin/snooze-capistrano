class zookeeper::zookeeperd ($zookeeperHosts=['localhost']){

  package { 'zookeeperd':
	  ensure 		=> installed,
		require   => Exec["apt-get_update"]
	}

	service { 'zookeeper':
	  ensure 		=> running,
		enable 		=> true,
		require 	=> Package["zookeeperd"]
  }

	file { '/etc/zookeeper/conf/zoo.cfg':
	  ensure 		=> present,
    content		=> template("zookeeper/zoo.cfg.erb"),
		notify		=> Service["zookeeper"], 
		require		=> Package["zookeeperd"]
	}

	file { '/etc/zookeeper/conf/myid':
	  ensure 		=> present,
		content 	=> $myid,
		notify		=> Service["zookeeper"], 
		require		=> Package["zookeeperd"]
  }


}
