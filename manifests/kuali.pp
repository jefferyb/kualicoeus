# == Class: kualicoeus::kuali
#
# Class to manage Kuali installs
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::kuali {
  if $kualicoeus::setup_tomcat == true {
    require ::kualicoeus::config::folders

    file { 'kc-config.xml File':
      ensure  => 'present',
      path    => "${kualicoeus::kc_config_home}/kc-config.xml",
      content => template('kualicoeus/kc-config.xml.erb'),
      notify  => Tomcat::Service['default'],
      mode    => '0664';
    }
  } else {
    require ::kualicoeus::config::folders

    file { 'kc-config.xml File':
      ensure  => 'present',
      path    => "${kualicoeus::kc_config_home}/kc-config.xml",
      content => template('kualicoeus/kc-config.xml.erb'),
      mode    => '0664';
    }
  }
}
