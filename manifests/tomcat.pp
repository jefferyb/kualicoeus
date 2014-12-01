#
# Using puppetlabs/tomcat module to install & configure tomcat
#
# For more information on the puppetlabs/tomcat module, please visit
# https://forge.puppetlabs.com/puppetlabs/tomcat
#

class kualicoeus::tomcat {
  if $kualicoeus::setup_tomcat == true {
    require kualicoeus::config::packages

    class { 'java': } ->
    class { '::tomcat': } ->
    tomcat::instance { 'kuali_instance':
      source_url    => $::kualicoeus::tomcat_source_url,
      catalina_base => $::kualicoeus::catalina_base,
    } ->
    file { "${::kualicoeus::catalina_base}/bin/setenv.sh":
      ensure  => 'present',
      content => template('kualicoeus/setenv.sh.erb'),
    } ->
    class { 'kualicoeus::config::connector': }
  }
}
