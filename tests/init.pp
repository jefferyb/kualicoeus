# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
class { 'kualicoeus':
  database_type    => 'ORACLE',
  application_host => 'localhost',
  http_port        => '8084',
  catalina_base    => '/opt/apache-tomcat/tomcat6',
  kc_source_folder => '/opt/kuali/source/5.2.1',
  kc_config_home   => '/opt/kuali/main/dev',
  kc_war_name      => 'kc-dev.war',
}

