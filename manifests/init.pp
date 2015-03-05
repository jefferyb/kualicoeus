#
# Class to manage installation and configuration of Kuali Coeus.
#

class kualicoeus (
  $setup_tomcat     = true, # Options: true, false
  $setup_database   = true, # Options: true, false
  $setup_p6spy      = false, # Options: true, false
  $setup_s2s        = false, # Options: true, false
  $setup_shibboleth = false, # Options: true, false
  $database_type    = 'MYSQL', # Options: 'MYSQL', 'ORACLE'
  $deactivate_firewall             = true, # Options: true, false

  # Database Settings:
  $db_driver_name   = undef,
  $db_driver_url    = undef,
  $db_driver_class_name            = undef,
  #

  # MySQL settings
  $mysql_root_pw    = $::kualicoeus::settings::mysql_root_pw,
  $db_hostname      = $::kualicoeus::settings::db_hostname,
  #
  $mysql_kc_install_dbsvrnm        = $::kualicoeus::settings::mysql_kc_install_dbsvrnm,
  #
  $kc_install_riceun               = 'riceusername',
  $kc_install_ricepw               = 'ricepassword',
  $kc_install_ricedbsvrnm          = 'krdev',
  $kc_install_ricehostname         = $::kualicoeus::db_hostname,
  #
  ###
  # Oracle settings
  $tnsnames_location               = $::kualicoeus::settings::tnsnames_location,
  $oracle_docker_image             = $::kualicoeus::settings::oracle_docker_image,
  #
  $oracle_kc_install_dbsvrnm       = $::kualicoeus::settings::oracle_kc_install_dbsvrnm,
  ###
  # tomcat Settings
  $catalina_base    = undef,
  $tomcat_file_name = undef,
  $tomcat_source_url               = undef,
  #
  # Kuali Coeus settings
  # WHEN CHANGING VERSION, MAKE SURE YOU SET $kc_version, $kc_release_file AND $kc_download_link
  $kc_version       = undef,
  $kc_release_file  = $::kualicoeus::settings::kc_release_file,
  $kc_download_link = $::kualicoeus::settings::kc_download_link,
  #
  # KC_Install.sh settings
  $kc_install_mode  = $::kualicoeus::settings::kc_install_mode,
  $kc_install_version              = $::kualicoeus::settings::kc_install_version,
  $kc_install_demo  = $::kualicoeus::settings::kc_install_demo,
  #
  # War File Settings
  #
  $kc_war_name      = $::kualicoeus::settings::kc_war_name,
  $kc_war_source    = undef,
  $kc_war_ensure    = $::kualicoeus::settings::kc_war_ensure,
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
  $kc_environment   = 'dev',
  $app_context_name = "kc-${kc_environment}",
  $build_version    = undef,
  # To turn ON/OFF Production Mode
  $production_environment_code     = 'xyz',
  # KC Client DB
  $datasource_url   = undef,
  $datasource_username             = undef,
  $datasource_password             = undef,
  $datasource_ojb_platform         = undef,
  # Oracle related
  $oracle_datasource_port          = '49161',
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
  # Shibboleth Settings:
  $shib_session_location           = undef,
  $shib_sslSessionCacheTimeout     = $::shibboleth::sslSessionCacheTimeout,
  #   mod_ssl Certificates
  $shib_manage_ssl_certificate     = $::shibboleth::manage_ssl_certificate,
  $shib_create_ssl_cert            = $::shibboleth::create_ssl_cert,
  $shib_sslCertificateChainFile    = $::shibboleth::sslCertificateChainFile,
  $shib_key_cert_source            = $::kualicoeus::settings::key_cert_source,
  $shib_csr_cert_source            = $::kualicoeus::settings::csr_cert_source,
  $shib_incommon_cert_source       = $::kualicoeus::settings::incommon_cert_source,
  #   Shibboleth Certificates
  $shib_manage_shib_certificate    = $::shibboleth::manage_shib_certificate,
  $shib_create_shib_cert           = $::shibboleth::create_shib_cert,
  $shib_key_source  = $::kualicoeus::settings::shib_key_source,
  $shib_cert_source = $::kualicoeus::settings::shib_cert_source,
  #
  $shib_discoveryProtocol          = 'idpURL', # Options: 'idpURL', 'discoveryURL' - Default: 'idpURL'
  $shib_idpURL      = undef,
  $shib_discoveryURL               = undef,
  $shib_provider_uri               = undef,
  $shib_backingFileName            = $::shibboleth::backingFileName,
  $shib_provider_reload_interval   = $::shibboleth::provider_reload_interval,
  #
  # P6Spy Settings:
  $p6spy_catalina_home             = undef,
  $p6spy_driver_name               = 'p6spy-2.1.3.jar',
  $p6spy_driver_url = 'http://mirrors.ibiblio.org/maven2/p6spy/p6spy/2.1.3/p6spy-2.1.3.jar',
  $p6spy_my_spy_file               = false,
  $p6spy_my_spy_file_source        = undef,
  $p6spy_my_spy_file_path          = undef,
  $p6spy_autoflush  = true,
  $p6spy_dateformat = 'MM-dd-yy HH:mm:ss:SS',
  $p6spy_stacktrace = false,
  $p6spy_stacktraceclass           = '',
  $p6spy_logfile    = undef,
  $p6spy_logMessageFormat          = 'com.p6spy.engine.spy.appender.MultiLineFormat',
  #
  # Kuali Upgrade Settings:
  $setup_kuali_upgrade             = false,
  $send_emails      = false,
  $email_address    = undef,
  $kc_upgrade_version              = undef,
  $kc_upgrade_file  = undef,
  $kc_upgrade_dl_link              = undef,

  #
  ) inherits ::kualicoeus::settings {
  # Kuali Coeus settings
  if $kc_version {
    if $setup_kuali_upgrade {
      $_kc_version = $kc_version
      $kc_source_folder = "/opt/kuali/source/${kc_upgrade_version}"
    } else {
      $_kc_version = $kc_version
      $kc_source_folder = "/opt/kuali/source/${kc_version}"
    }
  } else {
    #    $_kc_version = '5.2.1'
    #    $kc_source_folder = "/opt/kuali/source/5.2.1"
    $_kc_version = '6.0'
    $kc_source_folder = '/opt/kuali/source/6.0'
  }

  if versioncmp($_kc_version, '5.3') > 0 {
    if $catalina_base {
      $_catalina_base = $catalina_base
    } else {
      #     $_catalina_base = '/opt/apache-tomcat/tomcat7'
      $_catalina_base = '/opt/apache-tomcat/tomcat8'
    }

    if $tomcat_file_name {
      $_tomcat_file_name = $tomcat_file_name
    } else {
      #      $_tomcat_file_name = 'apache-tomcat-7.0.57.tar.gz'
      $_tomcat_file_name = 'apache-tomcat-8.0.18.tar.gz'
    }

    if $tomcat_source_url {
      $_tomcat_source_url = $tomcat_source_url
    } else {
      #      $_tomcat_source_url = 'http://supergsego.com/apache/tomcat/tomcat-7/v7.0.57/bin/apache-tomcat-7.0.57.tar.gz'
      $_tomcat_source_url = 'http://www.webhostingjams.com/mirror/apache/tomcat/tomcat-8/v8.0.18/bin/apache-tomcat-8.0.18.tar.gz'
    }
  } else {
    $_catalina_base = $::kualicoeus::settings::catalina_base
    $_tomcat_file_name = $::kualicoeus::settings::tomcat_file_name
    $_tomcat_source_url = $::kualicoeus::settings::tomcat_source_url
  }

  if $setup_kuali_upgrade {
    if $kualicoeus::kc_version == undef {
      fail('Please set "kc_version" to your current version number')
    }

    if $kualicoeus::kc_upgrade_version == undef {
      fail('Please set kc_upgrade_version')
    }

    if $kualicoeus::kc_upgrade_file == undef {
      fail('Please set kc_upgrade_file')
    }

    if $kualicoeus::kc_upgrade_dl_link == undef {
      fail('Please set kc_upgrade_dl_link')
    }
    $_kc_install_version = $_kc_version
    $_kc_release_file = $kc_upgrade_file
    $_kc_download_link = $kc_upgrade_dl_link
  } else {
    $_kc_install_version = $kc_install_version
    $_kc_release_file = $kc_release_file
    $_kc_download_link = $kc_download_link
  }

  if $build_version {
    $_build_version = $build_version
  } else {
    $_build_version = $_kc_version
  }

  if $kc_war_source {
    $_kc_war_source = $kc_war_source
  } else {
    $_kc_war_source = "${kc_source_folder}/binary/kc-ptd.war"
  }

  if $p6spy_logfile {
    $_p6spy_logfile = $p6spy_logfile
  } else {
    $_p6spy_logfile = "${::kualicoeus::_catalina_base}/logs/p6spy_sql.log"
  }

  if $p6spy_my_spy_file_path {
    $_p6spy_my_spy_file_path = $p6spy_my_spy_file_path
  } else {
    $_p6spy_my_spy_file_path = "${kualicoeus::_catalina_base}/conf/spy.properties"
  }

  # ## Database Settings:
  if $database_type == 'ORACLE' {
    if $datasource_url {
      $_datasource_url = $datasource_url
    } elsif $setup_p6spy {
      $_datasource_url = "jdbc:p6spy:oracle:thin:@${db_hostname}:49161:${oracle_kc_install_dbsvrnm}"
    } else {
      $_datasource_url = "jdbc:oracle:thin:@${db_hostname}:49161:${oracle_kc_install_dbsvrnm}"
    }

    if $datasource_username {
      $_datasource_username = $datasource_username
    } else {
      $_datasource_username = $::kualicoeus::oracle_kc_install_un
    }

    if $datasource_password {
      $_datasource_password = $datasource_password
    } else {
      $_datasource_password = $::kualicoeus::oracle_kc_install_pw
    }

    if $datasource_ojb_platform {
      $_datasource_ojb_platform = $datasource_ojb_platform
    } else {
      $_datasource_ojb_platform = 'Oracle9i'
    }

    if $db_driver_name {
      $_db_driver_name = $db_driver_name
    } else {
      $_db_driver_name = $kualicoeus::settings::oracle_driver_name
    }

    if $db_driver_url {
      $_db_driver_url = $db_driver_url
    } else {
      $_db_driver_url = $kualicoeus::settings::oracle_driver_url
    }

    if $db_driver_class_name {
      $_db_driver_class_name = $db_driver_class_name
    } elsif $setup_p6spy {
      $_db_driver_class_name = 'com.p6spy.engine.spy.P6SpyDriver'
      $driver_class_name = 'oracle.jdbc.driver.OracleDriver'
    } else {
      $_db_driver_class_name = 'oracle.jdbc.driver.OracleDriver'
    }
  }

  if $database_type == 'MYSQL' {
    if $datasource_url {
      $_datasource_url = $datasource_url
    } elsif $setup_p6spy {
      $_datasource_url = "jdbc:p6spy:mysql://${db_hostname}:3306/${mysql_kc_install_dbsvrnm}"
    } else {
      $_datasource_url = "jdbc:mysql://${db_hostname}:3306/${mysql_kc_install_dbsvrnm}"
    }

    if $datasource_username {
      $_datasource_username = $datasource_username
    } else {
      $_datasource_username = $::kualicoeus::mysql_kc_install_un
    }

    if $datasource_password {
      $_datasource_password = $datasource_password
    } else {
      $_datasource_password = $::kualicoeus::mysql_kc_install_pw
    }

    if $datasource_ojb_platform {
      $_datasource_ojb_platform = $datasource_ojb_platform
    } else {
      $_datasource_ojb_platform = 'MySQL'
    }

    if $db_driver_name {
      $_db_driver_name = $db_driver_name
    } else {
      $_db_driver_name = $kualicoeus::settings::mysql_driver_name
    }

    if $db_driver_url {
      $_db_driver_url = $db_driver_url
    } else {
      $_db_driver_url = $kualicoeus::settings::mysql_driver_url
    }

    if $db_driver_class_name {
      $_db_driver_class_name = $db_driver_class_name
    } elsif $setup_p6spy {
      $_db_driver_class_name = 'com.p6spy.engine.spy.P6SpyDriver'
      $driver_class_name = 'com.mysql.jdbc.Driver'
    } else {
      $_db_driver_class_name = 'com.mysql.jdbc.Driver'
    }
  }

  class { 'kualicoeus::config::packages':
  }

  class { 'kualicoeus::firewall':
  }

  class { 'kualicoeus::config::database':
  }

  class { 'kualicoeus::config::run_kc_demo_script':
  }

  class { 'kualicoeus::kuali':
  }

  class { 'kualicoeus::tomcat':
  }

  class { 'kualicoeus::config::p6spy':
  }

  class { 'kualicoeus::shibboleth':
  }

  class { 'kualicoeus::config::war_file':
  }

  Class['kualicoeus::config::packages'] ->
  Class['kualicoeus::firewall'] ->
  Class['kualicoeus::config::database'] ->
  Class['kualicoeus::config::run_kc_demo_script'] ->
  Class['kualicoeus::kuali'] ->
  Class['kualicoeus::tomcat'] ->
  Class['kualicoeus::config::p6spy'] ->
  Class['kualicoeus::shibboleth'] ->
  Class['kualicoeus::config::war_file']

}
