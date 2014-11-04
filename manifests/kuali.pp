#
# Class to manage Kuali installs
#

class kualicoeus::kuali {
  require kualicoeus::tomcat

  exec { 'Create Source Folder':
    command => "mkdir -p ${kualicoeus::kc_source_folder}",
    creates => $kualicoeus::kc_source_folder,
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  } ->
  staging::deploy { $kualicoeus::kc_release_file:
    source  => $kualicoeus::kc_download_link,
    target  => $kualicoeus::kc_source_folder,
    creates => "${kualicoeus::kc_source_folder}/quickstart_guide.txt",
  } ->
  exec { 'Create KC Config Folder':
    command => "mkdir -p ${kualicoeus::kc_config_home}",
    creates => $kualicoeus::kc_config_home,
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  } ->
  file {
    "${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install.sh":
      ensure  => 'present',
      content => template('kualicoeus/J_KC_Install.sh.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0744';

    "${kualicoeus::kc_source_folder}/db_scripts/main/LOGS/get_mysql_errors":
      ensure => 'present',
      source => 'puppet:///modules/kualicoeus/get_mysql_errors',
      owner  => 'root',
      group  => 'root',
      mode   => '0744';

    "${kualicoeus::kc_config_home}/kc-config.xml":
      ensure  => 'present',
      content => template('kualicoeus/kc-config.xml.erb'),
      mode    => '0664';
  } ->
  exec { 'Run KC_Config Script':
    cwd     => "${kualicoeus::kc_source_folder}/db_scripts/main",
    command => "bash J_KC_Install.sh && touch ${kualicoeus::kc_source_folder}/db_scripts/main/.KC_Config_Script_installed",
#    timeout => 0,
    creates => "${kualicoeus::kc_source_folder}/db_scripts/main/.KC_Config_Script_installed",
    before  => Tomcat::War[$::kualicoeus::kc_war_name],
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }

  if $::kualicoeus::kc_install_demo == true {
    exec { 'Stop tomcat to install KC Demo':
      cwd     => "${::kualicoeus::catalina_base}/bin",
      command => 'bash shutdown.sh -force',
      require => Exec ['Run KC_Config Script'],
      before  => Exec['Install KC Demo'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    } ->
    file { "${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install_Demo.sh":
        ensure  => 'present',
        content => template('kualicoeus/J_KC_Install_Demo.sh.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0744';
    } ->
    exec { 'Install KC Demo':
      cwd     => "${kualicoeus::kc_source_folder}/db_scripts/main",
      command => 'bash J_KC_Install_Demo.sh && touch .KC_Demo_Script_installed',
#      timeout => 0,
      creates => "${kualicoeus::kc_source_folder}/db_scripts/main/.KC_Demo_Script_installed",
      require => File ["${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install_Demo.sh"],
      before  => Exec['Start tomcat after installing KC Demo'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    } ->
    exec { 'Start tomcat after installing KC Demo':
      cwd     => "${::kualicoeus::catalina_base}/bin",
      command => 'bash startup.sh',
      require => Exec ['Install KC Demo'],
      before  => Tomcat::War[$::kualicoeus::kc_war_name],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    }
  }

  tomcat::war { $::kualicoeus::kc_war_name:
    catalina_base => $::kualicoeus::catalina_base,
    war_ensure    => $::kualicoeus::kc_war_ensure,
    war_source    => "${::kualicoeus::kc_source_folder}/binary/kc-ptd.war",
  }
}

