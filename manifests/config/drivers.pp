# == Class: kualicoeus::config::drivers
#
# Class to manage database driver files used by the kualicoeus module
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::config::drivers {
  if $kualicoeus::_db_driver_name == undef {
    fail("Please set 'db_driver_name' to the name of your database driver. e.g class { 'kualicoeus': db_driver_name => 'ojdbc6.jar' }"
    )
  }

  if $kualicoeus::_db_driver_url == undef {
    fail("Please set 'db_driver_url' to the location of your database driver. e.g class { 'kualicoeus': db_driver_url => 'puppet:///modules/kualicoeus/ojdbc6.jar' }"
    )
  }

  if ($kualicoeus::setup_tomcat) and ($kualicoeus::setup_database) and ($kualicoeus::database_type == 'ORACLE') {
    $driver_url = '/var/lib/docker/aufs/mnt/*/u01/app/oracle/product/11.2.0/xe/jdbc/lib/ojdbc6.jar'

    exec { 'Copying an Oracle driver':
      command => "cp ${driver_url} /tmp/ojdbc6.jar",
      creates => '/tmp/ojdbc6.jar',
      require => Docker::Run[docker_oracle_xe],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];
    }
  } else {
    staging::file { $kualicoeus::_db_driver_name:
      source => $kualicoeus::_db_driver_url,
      target => "${::kualicoeus::_catalina_base}/lib/${kualicoeus::_db_driver_name}",
    }
  }
}
