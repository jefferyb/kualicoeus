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
# ## SETTINGS FOR EACH HOST
case $hostname {
  'kcdev' : {
    $setup_my_shibboleth = false
    $my_database = 'KAULI'
    $my_database_pw = '123qwert987'
    $my_database_version = '6.0'
    $my_kc_version = '6.0'
    $my_kc_war_name = 'kc-dev.war'
    $my_shib_idpURL = 'https://idp.example.com/idp/shibboleth'
  }
  'kctst' : {
    $setup_my_shibboleth = true
    $my_database = 'COEUS'
    $my_database_pw = '54321zxcvbnm67890'
    $my_database_version = '5.2'
    $my_kc_version = '5.2'
    $my_kc_war_name = 'kc-ptd.war'
    $my_kc_war_source = 'puppet:///modules/kualicoeus/kc-ptd-dev-5.2.war'
    $my_shib_idpURL = 'https://idp.testshib.org/idp/shibboleth'
  }
  default : {
    $setup_my_shibboleth = true
    $my_database = 'COEUS'
    $my_database_pw = '54321zxcvbnm67890'
    $my_database_version = '5.2'
    $my_kc_version = '5.2'
    $my_kc_war_name = 'kc-ptd.war'
    $my_kc_war_source = 'puppet:///modules/kualicoeus/kc-ptd-dev-5.2.war'
    $my_shib_idpURL = 'https://idp.testshib.org/idp/shibboleth'
  }
}

############################################################################
### SETUP SQL+PLUS AND TNSNAMES.ORA ON THE SYSTEM #####
class { 'kualicoeus::config::sqlplus':
  oracle_service_name => $my_database, # SET oracle_kc_install_dbsvrnm ALSO
  oracle_hostname     => 'database.example.com',
  oracle_port         => '1521',
  tnsnames_location   => '/opt/oracle',
} ->
############################################################################
### SETUP KUALI COEUS #################
class { 'kualicoeus':
  deactivate_firewall           => false,
  setup_database                => false,
  # ### CURRENT DATABASE
  kc_version                    => $my_kc_version,
  oracle_kc_install_dbsvrnm     => $my_database,
  # ### RUN THE UPGRADE
  #    kc_version          => '5.2',
  #    setup_kuali_upgrade => true,
  #    kc_upgrade_version  => '6.0',
  #    kc_upgrade_file     => 'kc-release-6_0.zip',
  #    kc_upgrade_dl_link  => 'http://downloads.kc.kuali.org/6.0/kc-release-6_0.zip',

  # ### INSTALL DEMO DATA
  kc_install_demo               => false,
  # ## KC APPLICATION SETTINGS
  kc_war_name                   => $my_kc_war_name,
  kc_war_source                 => $my_kc_war_source,
  db_driver_name                => 'ojdbc6.jar',
  db_driver_url                 => 'puppet:///modules/kualicoeus/ojdbc6.jar',
  database_type                 => 'ORACLE',
  application_http_scheme       => 'https',
  http_port                     => '',
  kc_environment                => 'srv',
  build_version                 => "Software:: KC ${my_kc_version} | Database:: ${my_database} v${my_database_version}",
  datasource_url                => "jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=database.example.com)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${my_database})))",
  datasource_username           => 'dbuser',
  datasource_password           => $my_database_pw,
  mail_from                     => "no-reply@${::fqdn}",
  mailmessage_from              => "no-reply@${::fqdn}",
  kr_incident_mailing_list      => 'admin@example.com',
  encryption_key                => '3IC32w6kZMXN',
  # Shibboleth settings:
  setup_shibboleth              => $setup_my_shibboleth,
  shib_session_location         => 'kc-dev',
  shib_sslSessionCacheTimeout   => '1200',
  shib_provider_reload_interval => '600',
  shib_create_ssl_cert          => false,
  shib_sslCertificateChainFile  => true,
  shib_provider_uri             => 'http://www.testshib.org/metadata/testshib-providers.xml',
  shib_backingFileName          => 'idp.xml',
  shib_idpURL                   => $my_shib_idpURL,
  # P6spy Settings:
  setup_p6spy                   => false,
# datasource_url    =>
# "jdbc:p6spy:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=database.example.com)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=$my_database)))",
} ->
############################################################################
### APPLY OUR OWN CUSTOMIZATIONS ###

#  class { 'kc_customizations': }

############################################################################
### TURN ON/OFF EMAIL NOTIFICATIONS ###

class { 'kualicoeus::config::kew_notifications':
  kew_email_notifications             => 'Y',
  kew_from_address                    => "kew-no-reply@${::fqdn}",
  kew_email_notification_test_address => 'admin@example.com',
}

class { 'kualicoeus::config::kc_notifications':
  kc_email_notifications             => 'Y',
  kc_email_notification_from_address => "kc-no-reply@${::fqdn}",
  kc_email_notification_test_enabled => 'Y',
  kc_email_notification_test_address => 'admin@example.com',
}

############################################################################
