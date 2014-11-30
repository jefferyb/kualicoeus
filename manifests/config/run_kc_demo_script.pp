#
# Class to install the kc demo data
#

class kualicoeus::config::run_kc_demo_script {
  if $kualicoeus::kc_install_demo == true {
    if $kualicoeus::database_type == 'ORACLE' {
      require ::kualicoeus::oracle
    } else {
      require ::kualicoeus::mysql
    }

    exec { 'Stop tomcat to install KC Demo':
      cwd     => "${::kualicoeus::catalina_base}/bin",
      command => 'bash shutdown.sh -force',
      unless  => "grep -c 1 ${kualicoeus::kc_source_folder}/db_scripts/main/.KC_Demo_Script_installed_${kualicoeus::database_type}",
      before  => Exec['Install KC Demo'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    } ->
    file { 'Getting the demo install script':
      ensure  => 'present',
      path    => "${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install_Demo.sh",
      content => template('kualicoeus/J_KC_Install_Demo.sh.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0744';
    } ->
    exec { 'Install KC Demo':
      cwd     => "${kualicoeus::kc_source_folder}/db_scripts/main",
      command => "bash -c './J_KC_Install_Demo.sh'",
      creates => "${kualicoeus::kc_source_folder}/db_scripts/main/.KC_Demo_Script_installed_${kualicoeus::database_type}",
      require => File["${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install_Demo.sh"],
      before  => Exec['Start tomcat after installing KC Demo'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    } ->
    exec { 'Start tomcat after installing KC Demo':
      cwd     => "${::kualicoeus::catalina_base}/bin",
      command => "bash startup.sh; echo 1 > ${kualicoeus::kc_source_folder}/db_scripts/main/.KC_Demo_Script_installed_${kualicoeus::database_type}",
      unless  => "grep -c 1 ${kualicoeus::kc_source_folder}/db_scripts/main/.KC_Demo_Script_installed_${kualicoeus::database_type}",
      require => Exec['Install KC Demo'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    }
  }
}