#
# Class to manage settings of Kuali Coeus.
#

class kualicoeus::settings {
  # ## packages needed
  $install_pkgs = ['curl', 'wget', 'unzip']

  # For KC_Install.sh
  $kc_install_mode = 'BUNDLE' # BUNDLE EMBED
  $kc_install_version = 'NEW' # NEW 3.1.1 5.0 5.0.1 5.1 5.1.1 5.2

  # Oracle Settings
  $oracle_kc_install_un = 'system'
  $oracle_kc_install_pw = 'oracle'
  $oracle_kc_install_dbsvrnm = 'XE'
  $tnsnames_location = '/opt/oracle'

  $kc_install_demo = false

  # ## mysql settings
  $mysql_kc_install_un = 'username'
  $mysql_kc_install_pw = 'password'
  $mysql_kc_install_dbsvrnm = 'kuali'

  $mysql_root_pw = 'strongpassword'
  $username = $::kualicoeus::mysql_kc_install_un
  $password = $::kualicoeus::mysql_kc_install_pw
  $database = $::kualicoeus::mysql_kc_install_dbsvrnm
  $db_hostname = 'localhost'

  # ## MySQL Connector
  $mysql_connector_filename = 'mysql-connector-java-5.1.9.jar'
  $mysql_connector_url = 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.9/mysql-connector-java-5.1.9.jar'

  # ## Oracle Connector
  $oracle_connector_filename = 'ojdbc6.jar'
  $oracle_connector_url = '/var/lib/docker/aufs/mnt/*/u01/app/oracle/product/11.2.0/xe/jdbc/lib/ojdbc6.jar'

  # ## tomcat settings
  $catalina_base = '/opt/apache-tomcat/tomcat6'
  $tomcat_file_name = 'apache-tomcat-6.0.41.tar.gz'
  $tomcat_source_url = 'http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.41/bin/apache-tomcat-6.0.41.tar.gz'

  # ## kuali coeus settings
  $kc_kuali_base_folder = '/opt/kuali'
  $kc_source_folder = '/opt/kuali/source/5.2.1'
  $kc_config_home = '/opt/kuali/main/dev'
  $kc_release_file = 'kc-release-5_2_1.zip'
  $kc_download_link = 'http://downloads.kc.kuali.org/5.0/kc-release-5_2_1.zip'
  $kc_war_name = 'kc-dev.war'
  $kc_war_ensure = 'present'

}
