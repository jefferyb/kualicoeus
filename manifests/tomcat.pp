# == Class: kualicoeus::tomcat
#
# Using puppetlabs/tomcat module to install & configure tomcat
#
# For more information on the puppetlabs/tomcat module, please visit
# https://forge.puppetlabs.com/puppetlabs/tomcat
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::tomcat {
  if $kualicoeus::setup_tomcat == true {
    require kualicoeus::config::packages

    class { 'java': } ->
    class { '::tomcat': } ->
    tomcat::instance { 'kuali_instance':
      source_url    => $::kualicoeus::_tomcat_source_url,
      catalina_base => $::kualicoeus::_catalina_base,
    } ->
    file { "${::kualicoeus::_catalina_base}/bin/setenv.sh":
      ensure  => 'present',
      content => template('kualicoeus/setenv.sh.erb'),
    } ->
    class { 'kualicoeus::config::drivers': }
  }
}
