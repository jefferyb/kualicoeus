#
# Using puppetlabs/tomcat module to install & configure tomcat
#
# For more information on the puppetlabs/tomcat module, please visit
# https://forge.puppetlabs.com/puppetlabs/tomcat
#

class kualicoeus::configure_tomcat {
  # Installing
  class { 'tomcat': }
  tomcat::instance { 'kuali_instance':
    source_url    => $kualicoeus::settings::tomcat_source_url,
    catalina_base => $kualicoeus::settings::catalina_base,
  } ->
  # Configure
  tomcat::setenv::entry {
    'CATALINA_HOME':
      value       => [$kualicoeus::settings::catalina_base],
      config_file => "${kualicoeus::settings::catalina_base}/bin/setenv.sh";

    'CATALINA_PID':
      value       => ["${kualicoeus::settings::catalina_base}/conf/catalina.pid"],
      config_file => "${kualicoeus::settings::catalina_base}/bin/setenv.sh";

    'JAVA_OPTS':
      value       => [
        '-Djava.awt.headless=true',
        '-ea',
        '-Xmx1024m',
        '-XX:MaxPermSize=512m',
        '-XX:+UseConcMarkSweepGC',
        '-XX:+CMSClassUnloadingEnabled',
        "-Dalt.config.location=${kualicoeus::settings::kc_config_home}/kc-config.xml",
        ],
      quote_char  => '"',
      config_file => "${kualicoeus::settings::catalina_base}/bin/setenv.sh";
  } ->
  tomcat::service { 'default':
    use_jsvc      => false,
    use_init      => false,
    start_command => "${kualicoeus::settings::catalina_base}/bin/startup.sh",
    stop_command  => "${kualicoeus::settings::catalina_base}/bin/shutdown.sh -force",
    catalina_base => $kualicoeus::settings::catalina_base,
  }

}
