# == Class: kualicoeus::mysql
#
# Using puppetlabs/mysql module to install & configure MySQL server
#
# For more information on the puppetlabs/mysql module, please visit
# https://forge.puppetlabs.com/puppetlabs/mysql
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::mysql {
  # Install & Configure MySQL
  case $::operatingsystem {
    /^(RedHat|CentOS)$/ : {
      class { '::mysql::server':
        root_password    => $::kualicoeus::mysql_root_pw,
        restart          => true,
        override_options => {
          'mysqld' => {
            symbolic-links                 => '0',
            open_files_limit               => '20000',
            innodb_locks_unsafe_for_binlog => '1',
            default-storage-engine         => 'InnoDB',
            innodb                         => 'ON',
            net_buffer_length              => '32768',
            interactive_timeout            => '40000',
            wait_timeout                   => '40000',
            max_allowed_packet             => '16M',
            transaction-isolation          => 'READ-COMMITTED',
            lower_case_table_names         => '1',
            max_connections                => '1000',
          }
          ,
        }
      }
    }

    /^(Ubuntu|Debian)$/ : {
      class { '::mysql::server':
        root_password    => $::kualicoeus::mysql_root_pw,
        restart          => true,
        override_options => {
          'mysqld' => {
            max_allowed_packet     => '16M',
            transaction-isolation  => 'READ-COMMITTED',
            lower_case_table_names => '1',
            max_connections        => '1000',
          }
        }
      }
    }

    default             : {
      fail("${::operatingsystem} is not currently supported")
    }
  }

  # Configure MySQL
  mysql::db { $::kualicoeus::mysql_kc_install_dbsvrnm:
    user     => $::kualicoeus::_datasource_username,
    password => $::kualicoeus::_datasource_password,
    host     => $::kualicoeus::db_hostname,
    charset  => 'utf8',
    collate  => 'utf8_bin',
  }

  mysql_grant { "${::kualicoeus::_datasource_username}@${::kualicoeus::db_hostname}/*.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => [
      'SELECT',
      'INSERT',
      'UPDATE',
      'DELETE',
      'CREATE',
      'DROP',
      'INDEX',
      'ALTER',
      'CREATE TEMPORARY TABLES',
      'LOCK TABLES',
      'CREATE VIEW',
      'CREATE ROUTINE'],
    table      => '*.*',
    user       => "${::kualicoeus::_datasource_username}@${::kualicoeus::db_hostname}",
  }

  if $kualicoeus::kc_install_mode == 'EMBED' {
    mysql::db { $::kualicoeus::kc_install_ricedbsvrnm:
      user     => $::kualicoeus::kc_install_riceun,
      password => $::kualicoeus::kc_install_ricepw,
      host     => $::kualicoeus::db_hostname,
      charset  => 'utf8',
      collate  => 'utf8_bin',
    }

    mysql_grant { "${::kualicoeus::kc_install_riceun}@${::kualicoeus::kc_install_ricehostname}/*.*":
      ensure     => 'present',
      options    => ['GRANT'],
      privileges => [
        'SELECT',
        'INSERT',
        'UPDATE',
        'DELETE',
        'CREATE',
        'DROP',
        'INDEX',
        'ALTER',
        'CREATE TEMPORARY TABLES',
        'LOCK TABLES',
        'CREATE VIEW',
        'CREATE ROUTINE'],
      table      => '*.*',
      user       => "${::kualicoeus::kc_install_riceun}@${::kualicoeus::kc_install_ricehostname}",
    }
  }

  class { '::mysql::bindings':
    java_enable => 1,
  }
}