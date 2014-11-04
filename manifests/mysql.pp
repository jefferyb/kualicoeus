#
# Using puppetlabs/mysql module to install & configure MySQL server
#
# For more information on the puppetlabs/mysql module, please visit
# https://forge.puppetlabs.com/puppetlabs/mysql
#

class kualicoeus::mysql {
  # Install & Configure MySQL
  case $::operatingsystem {
    /^(RedHat|CentOS)$/ : {
      if $::kualicoeus::settings::osver[0] >= '7' {
        class { '::mysql::client': package_name => $::kualicoeus::settings::mysql_client_package_name, }

        class { '::mysql::server':
          package_name     => $::kualicoeus::settings::mysql_package_name,
          service_name     => $::kualicoeus::settings::mysql_service_name,
          config_file      => $::kualicoeus::settings::mysql_config_file,
          root_password    => $::kualicoeus::mysql_root_pw,
          restart          => true,
          override_options => {
            'mysqld'      => {
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
            'mysqld_safe' => {
              log-error => '/var/log/mariadb/mariadb.log',
              pid-file  => '/var/run/mariadb/mariadb.pid',
            }
          }
        }

      } else {
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
  mysql::db { $::kualicoeus::kc_install_DBSvrNm:
    user     => $::kualicoeus::kc_install_un,
    password => $::kualicoeus::kc_install_pw,
    host     => $::kualicoeus::settings::hostname,
    charset  => 'utf8',
    collate  => 'utf8_bin',
  }

  mysql_grant { "${::kualicoeus::kc_install_un}@${::kualicoeus::settings::hostname}/*.*":
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
    user       => "${::kualicoeus::kc_install_un}@${::kualicoeus::settings::hostname}",
  }

  class { '::mysql::bindings':
    java_enable => 1,
  }
}