#
# Class to manage installation and configuration of Kuali Coeus.
#

class kualicoeus (
  $setup_tomcat     = true, # Options: 'true', 'false'
  $setup_database   = true, # Options: 'true', 'false'
  $database_type    = 'MYSQL', # Options: 'MYSQL', 'ORACLE'
  $deactivate_firewall             = true, # Options: 'true', 'false'

  $activate_s2s     = 'NO', # Options: 'YES', 'NO'
  $activate_shibboleth             = 'NO', # Options: 'YES', 'NO' - WORKING ON IT... STILL HAS NOT BEEN IMPLEMENTED YET...

  # MySQL settings
  $mysql_root_pw    = $::kualicoeus::settings::mysql_root_pw,
  $db_hostname      = $::kualicoeus::settings::db_hostname,
  #
  $mysql_kc_install_un             = $::kualicoeus::settings::mysql_kc_install_un,
  $mysql_kc_install_pw             = $::kualicoeus::settings::mysql_kc_install_pw,
  $mysql_kc_install_dbsvrnm        = $::kualicoeus::settings::mysql_kc_install_dbsvrnm,
  #
  $kc_install_riceun               = 'riceusername',
  $kc_install_ricepw               = 'ricepassword',
  $kc_install_ricedbsvrnm          = 'krdev',
  $kc_install_ricehostname         = "${db_hostname}",
  #
  $mysql_connector_filename        = $::kualicoeus::settings::mysql_connector_filename,
  $mysql_connector_url             = $::kualicoeus::settings::mysql_connector_url,
  #
  # Oracle settings
  $tnsnames_location               = $::kualicoeus::settings::tnsnames_location,
  #
  $oracle_kc_install_un            = $::kualicoeus::settings::oracle_kc_install_un,
  $oracle_kc_install_pw            = $::kualicoeus::settings::oracle_kc_install_pw,
  $oracle_kc_install_dbsvrnm       = $::kualicoeus::settings::oracle_kc_install_dbsvrnm,
  #
  $oracle_connector_filename       = $::kualicoeus::settings::oracle_connector_filename,
  $oracle_connector_url            = $::kualicoeus::settings::oracle_connector_url,
  #
  # tomcat Settings
  $catalina_base    = $::kualicoeus::settings::catalina_base,
  $tomcat_file_name = $::kualicoeus::settings::tomcat_file_name,
  $tomcat_source_url               = $::kualicoeus::settings::tomcat_source_url,
  #
  # Kuali Coeus settings
  $kc_release_file  = $::kualicoeus::settings::kc_release_file,
  $kc_download_link = $::kualicoeus::settings::kc_download_link,
  $kc_source_folder = $::kualicoeus::settings::kc_source_folder,
  #
  # War File Settings
  #
  $kc_war_name      = $::kualicoeus::settings::kc_war_name,
  $kc_war_source    = "${kc_source_folder}/binary/kc-ptd.war",
  $kc_war_ensure    = $::kualicoeus::settings::kc_war_ensure,
  #
  # KC_Install.sh settings
  $kc_install_mode  = $::kualicoeus::settings::kc_install_mode,
  $kc_install_version              = $::kualicoeus::settings::kc_install_version,
  $kc_install_demo  = $::kualicoeus::settings::kc_install_demo,
  #
  ##
  # kc-config.xml settings
  #
  # App specific parameters
  $kc_config_home   = $::kualicoeus::settings::kc_config_home,
  #
  $application_http_scheme         = 'http',
  $application_host = $::fqdn,
  $http_port        = '8080',
  $environment      = 'dev',
  $build_version    = '5.2.1',
  # To turn ON/OFF Production Mode
  $production_environment_code     = 'xyz',
  # KC Client DB
  # Oracle related
  $oracle_datasource_port          = '49161',
  $oracle_datasource_url           = "jdbc:oracle:thin:@${db_hostname}:49161:${oracle_kc_install_dbsvrnm}",
  $oracle_datasource_username      = "${oracle_kc_install_un}",
  $oracle_datasource_password      = "${oracle_kc_install_pw}",
  $oracle_datasource_ojb_platform  = 'Oracle9i',
  # MySQL related
  $mysql_datasource_url            = "jdbc:mysql://${db_hostname}:3306/${mysql_kc_install_dbsvrnm}",
  $mysql_datasource_username       = "${mysql_kc_install_un}",
  $mysql_datasource_password       = "${mysql_kc_install_pw}",
  $mysql_datasource_ojb_platform   = 'MySQL',
  # KC Client DB - Oracle Related Settings
  $oracle_datasource_driver_name   = 'oracle.jdbc.driver.OracleDriver',
  $mysql_datasource_driver_name    = 'com.mysql.jdbc.Driver',
  # Java mail properties
  $mail_smtp_host   = '127.0.0.1',
  $mail_smtp_port   = '25',
  $mail_smtp_username              = 'userId',
  $mail_user_password              = 'password',
  $mail_smtp_auth   = false,
  $mail_from        = "${::hostname}@${::fqdn}",
  $mail_relay_server               = '127.0.0.1',
  # Configuration for Exception Incident handling and reporting
  $kualiexceptionhandleraction_exception_incident_report_service = 'knsExceptionIncidentService',
  $mailmessage_from = "admin@${::fqdn}",
  $kualiexceptionincidentserviceimpl_additionalexceptionnamelist = '',
  $kualiexceptionincidentserviceimpl_report_mail_list            = "kc.tech.leads@${::fqdn}",
  $kr_incident_mailing_list        = "root@${::fqdn}",
  # Kuali parameters
  $mailing_list_batch              = 'mailing.list.batch',
  $encryption_key   = '7IC32w3kABCD',
  # To allow for pass-through Shibboleth authentication
  $filter_login_class              = 'org.kuali.rice.krad.web.filter.UserLoginFilter',
  $filtermapping_login_1           = '/*',
  # S2S Configuration
  $grants_gov_s2s_host             = '${grants.gov.s2s.host.development}',
  $grants_gov_s2s_port             = 'ApplicantIntegrationSoapPort',
  $grants_gov_s2s_host_production  = 'https://ws07.grants.gov:446/app-s2s-server/services',
  $grants_gov_s2s_host_development = 'https://at07ws.grants.gov:446/app-s2s-server/services',
  $s2s_keystore_password           = 'ks-password',
  $s2s_keystore_location           = '/kra/s2s/keystore/kc_org.jks',
  $s2s_truststore_location         = '/kra/s2s/keystore/cacerts.jks',
  $s2s_truststore_password         = 'ts-password',
  #
  ) inherits ::kualicoeus::settings {
  class { 'kualicoeus::config::packages': }

  class { 'kualicoeus::firewall': }

  class { 'kualicoeus::config::database': }

  class { 'kualicoeus::config::run_kc_demo_script': }

  class { 'kualicoeus::tomcat': }

  class { 'kualicoeus::config::connector': }

  class { 'kualicoeus::kuali': }

  class { 'kualicoeus::config::war_file': }

  Class['kualicoeus::config::packages'] ->
  Class['kualicoeus::firewall'] ->
  Class['kualicoeus::config::database'] ->
  Class['kualicoeus::config::run_kc_demo_script'] ->
  Class['kualicoeus::tomcat'] ->
  Class['kualicoeus::config::connector'] ->
  Class['kualicoeus::kuali'] ->
  Class['kualicoeus::config::war_file']

}
