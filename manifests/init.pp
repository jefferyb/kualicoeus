#
# Class to manage installation and configuration of Kuali Coeus.
#

class kualicoeus {
  include kualicoeus::settings
  require kualicoeus::configure_firewall
  require kualicoeus::configure_mysql
  require java
  require kualicoeus::configure_tomcat

  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'] }

  package { $kualicoeus::settings::install_pkgs: ensure => installed } ->
  # Download & Extract the Kuali Coeus Release Files
  exec {
    'KC_Folders':
      command => $kualicoeus::settings::kc_create_folders,
      creates => $kualicoeus::settings::kc_config_home,
      before  => Exec["Downloading_KC_${kualicoeus::settings::kc_version}"];

    "Downloading_KC_${kualicoeus::settings::kc_version}":
      cwd     => $kualicoeus::settings::kc_coeus_folder,
      command => "wget ${kualicoeus::settings::kc_source}",
      creates => "${kualicoeus::settings::kc_coeus_folder}/${kualicoeus::settings::kc_release_file}",
      before  => Exec["Extracting_KC_${kualicoeus::settings::kc_version}"];

    "Extracting_KC_${kualicoeus::settings::kc_version}":
      cwd     => $kualicoeus::settings::kc_coeus_folder,
      command => $kualicoeus::settings::kc_extract_release_file,
      creates => "${kualicoeus::settings::kc_coeus_folder}/quickstart_guide.txt",
      before  => Exec['Running_KC_Config_Script'];
  } ->
  # Get the KC Install Script & Setup the kc-config file
  file {
    "${kualicoeus::settings::kc_install_folder}/J_KC_Install.sh":
      ensure => 'present',
      source => 'puppet:///modules/kualicoeus/J_KC_Install.sh',
      owner  => 'root',
      group  => 'root',
      mode   => '0777';

    "${kualicoeus::settings::kc_install_folder}/LOGS/get_mysql_errors":
      ensure => 'present',
      source => 'puppet:///modules/kualicoeus/get_mysql_errors',
      owner  => 'root',
      group  => 'root',
      mode   => '0777';

    "${kualicoeus::settings::kc_config_home}/kc-config.xml":
      ensure  => 'present',
      content => template('kualicoeus/kc-config.xml.erb'),
      mode    => '0664';
  } ->
  # Download the MySQL Connector, Run the KC Install Script & Deploy the Vanilla WAR File
  exec {
    'MySQL Connector':
      cwd     => "${kualicoeus::settings::catalina_base}/lib",
      command => "wget ${kualicoeus::settings::connector_url}",
      creates => "${kualicoeus::settings::catalina_base}/lib/${kualicoeus::settings::connector_filename}",
      before  => Exec['Running_KC_Config_Script'];

    'Running_KC_Config_Script':
      cwd     => $kualicoeus::settings::kc_install_folder,
      command => "bash J_KC_Install.sh && touch ${kualicoeus::settings::kc_install_folder}/.KC_Config_Script_installed",
      creates => "${kualicoeus::settings::kc_install_folder}/.KC_Config_Script_installed",
      before  => Exec['Deploy Vanilla WAR File'],
      require => File[
        "${kualicoeus::settings::kc_install_folder}/J_KC_Install.sh",
        "${kualicoeus::settings::kc_install_folder}/LOGS/get_mysql_errors"];

    'Deploy Vanilla WAR File':
      cwd     => "${kualicoeus::settings::kc_coeus_folder}/binary",
      command => $kualicoeus::settings::kc_deploy_war_cmd,
      creates => "${kualicoeus::settings::catalina_base}/webapps/kc-dev.war",
      require => File["${kualicoeus::settings::kc_config_home}/kc-config.xml"];
  }

}
