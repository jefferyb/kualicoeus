# == Class: kualicoeus::config::war_file
#
# Class to manage war file used by the kualicoeus module
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::config::war_file {
  if $kualicoeus::setup_tomcat == true {
    $kc_folder = "$(basename ${::kualicoeus::kc_war_name} .war)"
    file { "${::kualicoeus::_catalina_base}/webapps/${::kualicoeus::kc_war_name}":
      ensure => $::kualicoeus::kc_war_ensure,
      source => $::kualicoeus::_kc_war_source,
      notify => Exec['Removing the Old KC Folders'],
    } ->
    exec { 'Removing the Old KC Folders':
      cwd         => "${::kualicoeus::_catalina_base}/webapps",
      command     => "rm -fr ${kc_folder}",
      refreshonly => true,
      path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];
    } ~>
    tomcat::service { 'default':
      use_jsvc      => false,
      use_init      => false,
      start_command => "${::kualicoeus::_catalina_base}/bin/startup.sh",
      stop_command  => "${::kualicoeus::_catalina_base}/bin/shutdown.sh -force",
      catalina_base => $::kualicoeus::_catalina_base,
    }
  }
}
