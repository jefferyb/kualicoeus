# == Class: kualicoeus::settings
#
# Class to manage settings of Kuali Coeus.
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::settings {
  # ## packages needed
  $install_pkgs = ['curl', 'wget', 'unzip']

  # For KC_Install.sh
  $kc_install_mode = 'BUNDLE' # BUNDLE EMBED
  $kc_install_version = 'NEW' # NEW 3.1.1 5.0 5.0.1 5.1 5.1.1 5.2 5.2.1

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
  $db_hostname = 'localhost'

  # ## MySQL Driver
  $mysql_driver_name = 'mysql-connector-java-5.1.34.jar'
  $mysql_driver_url = 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar'

  # ## Oracle Driver
  $oracle_driver_name = 'ojdbc6.jar'
  $oracle_driver_url = '/tmp/ojdbc6.jar'
  $oracle_docker_image = 'alexeiled/docker-oracle-xe-11g'

  # ## tomcat settings
  $catalina_base = '/opt/apache-tomcat/tomcat8'
  $tomcat_file_name = 'apache-tomcat-8.0.18.tar.gz'
  $tomcat_source_url = 'http://www.webhostingjams.com/mirror/apache/tomcat/tomcat-8/v8.0.18/bin/apache-tomcat-8.0.18.tar.gz'

  # ## kuali coeus settings
  $kc_kuali_base_folder = '/opt/kuali'
  $kc_config_home = '/opt/kuali/main/dev'
  $kc_release_file = 'kc-release-6_0.zip'
  $kc_download_link = 'http://downloads.kc.kuali.org/6.0/kc-release-6_0.zip'
  $kc_war_name = 'kc-dev.war'
  $kc_war_ensure = 'present'

  # ## shibboleth settings
  #     mod_ssl certs
  $key_cert_source = "puppet:///modules/kualicoeus/${::hostname}.key"
  $csr_cert_source = "puppet:///modules/kualicoeus/${::hostname}.crt"
  $incommon_cert_source = "puppet:///modules/kualicoeus/${::hostname}.incommon-chain.crt"
  #     shib certs
  $shib_key_source = "puppet:///modules/kualicoeus/${::hostname}.sp-key.pem"
  $shib_cert_source = "puppet:///modules/kualicoeus/${::hostname}.sp-cert.pem"
}
