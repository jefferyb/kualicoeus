#
# Using puppetlabs/mysql module to install & configure MySQL server
#
# For more information on the puppetlabs/mysql module, please visit
# https://forge.puppetlabs.com/puppetlabs/mysql
#

class kualicoeus::configure_mysql {
  # Install & Configure MySQL
  case $::operatingsystem {
    /^(RedHat|CentOS)$/ : {
      class { '::mysql::server':
        root_password    => $kualicoeus::settings::root_pw,
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
        root_password    => $kualicoeus::settings::root_pw,
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

  mysql::db { $kualicoeus::settings::database:
    user     => $kualicoeus::settings::username,
    password => $kualicoeus::settings::password,
    host     => $kualicoeus::settings::hostname,
    charset  => 'utf8',
    collate  => 'utf8_bin',
  }

  mysql_grant { "${kualicoeus::settings::username}@localhost/*.*":
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
    user       => "${kualicoeus::settings::username}@localhost",
  }

  class { '::mysql::bindings':
    java_enable => 1,
  }
}
