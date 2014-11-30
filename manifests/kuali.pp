#
# Class to manage Kuali installs
#

class kualicoeus::kuali {
  require ::kualicoeus::config::folders

  $restart_tomcat_command = "${::kualicoeus::catalina_base}/bin/shutdown.sh -force; sleep 3; ${::kualicoeus::catalina_base}/bin/startup.sh"

  file { 'kc-config.xml File':
    ensure  => 'present',
    path    => "${kualicoeus::kc_config_home}/kc-config.xml",
    content => template('kualicoeus/kc-config.xml.erb'),
    mode    => '0664';
  }

  if $kualicoeus::setup_tomcat == true {
    exec { 'Restart tomcat':
      command     => $restart_tomcat_command,
      subscribe   => [File["${kualicoeus::kc_config_home}/kc-config.xml"], Tomcat::War[$::kualicoeus::kc_war_name]],
      refreshonly => true,
      path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    }
  }
}
