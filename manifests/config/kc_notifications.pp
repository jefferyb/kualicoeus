#
# Class to manage KC-GEN | kc e-mail notifications
#

class kualicoeus::config::kc_notifications (
  # KC-GEN | KC related email parameters
  $database_type = $kualicoeus::database_type,
  $kc_email_notifications, # Enables email notifications to be sent
  $kc_email_notification_from_address, # KC Email Service uses this param to set the default from address for sending email notifications
  $kc_email_notification_test_enabled, # Set email notifications to TEST MODE
  $kc_email_notification_test_address, # Email notifications will be sent to this id if EMAIL_NOTIFICATION_TEST_ENABLED ($kc_email_notification_test_enabled) set to Y
  ) {

  if $database_type == 'ORACLE' {
    $set_kc_paramaters_script = "sqlplus ${::kualicoeus::oracle_kc_install_un}/${::kualicoeus::oracle_kc_install_pw}@${::kualicoeus::oracle_kc_install_dbsvrnm} < ${kualicoeus::kc_config_home}/config/kc_email_notifications.sql"
  } elsif $database_type == 'MYSQL' {
    $set_kc_paramaters_script = "mysql -u ${::kualicoeus::mysql_kc_install_un} -p${::kualicoeus::mysql_kc_install_pw} ${::kualicoeus::mysql_kc_install_dbsvrnm} < ${kualicoeus::kc_config_home}/config/kc_email_notifications.sql"
  } else {
    fail("Database ${database_type} is not supported yet. Only 'MYSQL' and 'ORACLE' are supported")
  }

  # TURN ON/OFF E-MAIL NOTIFICATIONS
  file { 'Getting kc email notifications sql script':
    ensure  => 'present',
    path    => "${kualicoeus::kc_config_home}/config/kc_email_notifications.sql",
    content => template('kualicoeus/kc_email_notifications.sql.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744';
  } ->
  exec { 'Set KC related email parameters':
    command     => "bash -c 'export TNS_ADMIN=${::kualicoeus::tnsnames_location}; ${set_kc_paramaters_script}'",
    subscribe   => File["${kualicoeus::kc_config_home}/config/kc_email_notifications.sql"],
    refreshonly => true,
    path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }
}
