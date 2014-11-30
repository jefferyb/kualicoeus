#
# Class to setup the database used by the kualicoeus module
#

class kualicoeus::config::database {
  if $kualicoeus::setup_database == true {
    require kualicoeus::config::download

    if $kualicoeus::database_type == 'ORACLE' {
      require ::kualicoeus::oracle
    } elsif $kualicoeus::database_type == 'MYSQL' {
      require ::kualicoeus::mysql
    } else {
      fail("Database ${kualicoeus::database_type} is not supported yet. Only 'MYSQL' and 'ORACLE' are supported")
    }

    if $kualicoeus::kc_install_mode == 'EMBED' {
      fail('******* EMBED MODE HAS NOT BEEN IMPLEMENTED YET... *******')
    } else {
      file {
        "${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install.sh":
          ensure  => 'present',
          content => template('kualicoeus/J_KC_Install.sh.erb'),
          require => Staging::Deploy[$kualicoeus::kc_release_file],
          owner   => 'root',
          group   => 'root',
          mode    => '0744';

        "${kualicoeus::kc_source_folder}/db_scripts/main/LOGS/get_mysql_errors":
          ensure  => 'present',
          source  => 'puppet:///modules/kualicoeus/get_mysql_errors',
          require => Staging::Deploy[$kualicoeus::kc_release_file],
          owner   => 'root',
          group   => 'root',
          mode    => '0744';
      } ->
      exec { 'Run KC_Config Script':
        cwd     => "${kualicoeus::kc_source_folder}/db_scripts/main",
        command => "bash -c './J_KC_Install.sh' && touch ${kualicoeus::kc_source_folder}/db_scripts/main/.KC_Config_Script_installed_${kualicoeus::database_type}",
        creates => "${kualicoeus::kc_source_folder}/db_scripts/main/.KC_Config_Script_installed_${kualicoeus::database_type}",
        require => Staging::Deploy[$kualicoeus::kc_release_file],
        path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
      }
    }
  }
}