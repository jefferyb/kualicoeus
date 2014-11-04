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
class { "kualicoeus":
  kc_install_un      => 'myusername',
  kc_install_pw      => 'mypassword',
  kc_install_DBSvrNm => 'mydatabase',
  connector_url      => 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.8/mysql-connector-java-5.1.8.jar',
  connector_filename => 'mysql-connector-java-5.1.8.jar',
  catalina_base      => '/opt/apache-tomcat/tomcat6',
  kc_source_folder   => '/opt/kuali/source/5.2.1',
  kc_config_home     => '/opt/kuali/main/dev',
  kc_war_name        => 'kc-dev.war',
}

