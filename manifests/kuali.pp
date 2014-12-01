#
# Class to manage Kuali installs
#

class kualicoeus::kuali {
  require ::kualicoeus::config::folders

  file { 'kc-config.xml File':
    ensure  => 'present',
    path    => "${kualicoeus::kc_config_home}/kc-config.xml",
    content => template('kualicoeus/kc-config.xml.erb'),
    notify  => Tomcat::Service['default'],
    mode    => '0664';
  }
}
