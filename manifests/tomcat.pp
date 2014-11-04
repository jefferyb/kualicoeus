#
# Using puppetlabs/tomcat module to install & configure tomcat
#
# For more information on the puppetlabs/tomcat module, please visit
# https://forge.puppetlabs.com/puppetlabs/tomcat
#

class kualicoeus::tomcat {
  require ::kualicoeus::packages
  require ::kualicoeus::mysql
  # Install tomcat
  class { '::tomcat':
  }
  tomcat::instance { 'kuali_instance':
    source_url    => $::kualicoeus::tomcat_source_url,
    catalina_base => $::kualicoeus::catalina_base,
  } ->
  # Configure
  # THIS FEATURE IS BROKEN IN THE CURRENT VERSION, puppetlabs-tomcat 1.0.1,
  # BUT WILL TURN IT BACK ON ONCE IT IS RESOLVED
  # (Their github version of tomcat has the patch but hasn't been brought to the forge)
  #  tomcat::setenv::entry {
  #    'CATALINA_HOME':
  #      value       => [$kualicoeus::catalina_base],
  #      config_file => "${kualicoeus::catalina_base}/bin/setenv.sh";
  #
  #    'CATALINA_PID':
  #      value       => ["${kualicoeus::catalina_base}/conf/catalina.pid"],
  #      config_file => "${kualicoeus::catalina_base}/bin/setenv.sh";
  #
  #    'JAVA_OPTS':
  #      value       => [
  #        '-Djava.awt.headless=true',
  #        '-ea',
  #        '-Xmx1024m',
  #        '-XX:MaxPermSize=512m',
  #        '-XX:+UseConcMarkSweepGC',
  #        '-XX:+CMSClassUnloadingEnabled',
  #        "-Dalt.config.location=${kualicoeus::kc_config_home}/kc-config.xml",
  #        ],
  #      quote_char  => '"',
  #      config_file => "${kualicoeus::catalina_base}/bin/setenv.sh";
  #  } ->

  # Download MySQL Connector
  staging::file { $::kualicoeus::connector_filename:
    source => $::kualicoeus::connector_url,
    target => "${::kualicoeus::catalina_base}/lib/${::kualicoeus::connector_filename}",
  } ->
  file { "${::kualicoeus::catalina_base}/bin/setenv.sh":
    ensure  => 'present',
    content => template('kualicoeus/setenv.sh.erb'),
  } ->
  tomcat::service { 'default':
    use_jsvc      => false,
    use_init      => false,
    start_command => "${::kualicoeus::catalina_base}/bin/startup.sh",
    stop_command  => "${::kualicoeus::catalina_base}/bin/shutdown.sh -force",
    catalina_base => $::kualicoeus::catalina_base,
  }
}

