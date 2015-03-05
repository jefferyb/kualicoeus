# == Class: kualicoeus::config::run_kc_demo_script
#
# Class to install the kc demo data
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::config::run_kc_demo_script {
  if $kualicoeus::kc_install_demo == true {
    if $kualicoeus::database_type == 'ORACLE' {
      require ::kualicoeus::oracle
    } else {
      require ::kualicoeus::mysql
    }

    exec { 'Stopping tomcat to install KC Demo':
      cwd     => "${::kualicoeus::_catalina_base}/bin",
      command => 'bash shutdown.sh -force',
      unless  => "grep -c ${::kualicoeus::_kc_version} ${::kualicoeus::kc_config_home}/config/KC_Demo_Script_installed_${kualicoeus::database_type}.v.${::kualicoeus::_kc_version}",
      before  => Exec['Installing KC Demo'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    } ->
    file { 'Getting the demo install script':
      ensure  => 'present',
      path    => "${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install_Demo.sh",
      content => template("kualicoeus/J_KC_Install_Demo.${::kualicoeus::_kc_version}.sh.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0744';
    } ->
    exec { 'Installing KC Demo':
      cwd     => "${kualicoeus::kc_source_folder}/db_scripts/main",
      command => "bash -c './J_KC_Install_Demo.sh'",
      creates => "${::kualicoeus::kc_config_home}/config/KC_Demo_Script_installed_${kualicoeus::database_type}.v.${::kualicoeus::_kc_version}",
      require => File["${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install_Demo.sh"],
      before  => Exec['Restarting tomcat after installing KC Demo'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    } ->
    exec { 'Restarting tomcat after installing KC Demo':
      cwd     => "${::kualicoeus::_catalina_base}/bin",
      command => "bash startup.sh; echo ${::kualicoeus::_kc_version} > ${::kualicoeus::kc_config_home}/config/KC_Demo_Script_installed_${kualicoeus::database_type}.v.${::kualicoeus::_kc_version}",
      unless  => "grep -c ${::kualicoeus::_kc_version} ${::kualicoeus::kc_config_home}/config/KC_Demo_Script_installed_${kualicoeus::database_type}.v.${::kualicoeus::_kc_version}",
      require => Exec['Installing KC Demo'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    }
  }
}