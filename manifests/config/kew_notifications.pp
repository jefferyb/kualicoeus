#
# Class to manage KR-WKFLW | kew e-mail notifications
#

class kualicoeus::config::kew_notifications (
  # KR-WKFLW | KEW related email parameters
  $kew_email_notifications,
  $kew_from_address, # Default from email address for notifications
  $kew_email_notification_test_address, # Default email address used for testing
  $database_type = $kualicoeus::database_type,) {

  if $database_type == 'ORACLE' {
    $set_kew_paramaters_script = "sqlplus ${::kualicoeus::oracle_kc_install_un}/${::kualicoeus::oracle_kc_install_pw}@${::kualicoeus::oracle_kc_install_dbsvrnm} < ${kualicoeus::kc_config_home}/config/kew_email_notifications.sql"
  } elsif $database_type == 'MYSQL' {
    $set_kew_paramaters_script = "mysql -u ${::kualicoeus::mysql_kc_install_un} -p${::kualicoeus::mysql_kc_install_pw} ${::kualicoeus::mysql_kc_install_dbsvrnm} < ${kualicoeus::kc_config_home}/config/kew_email_notifications.sql"
  } else {
    fail("Database ${database_type} is not supported yet. Only 'MYSQL' and 'ORACLE' are supported")
  }

  # TURN ON/OFF E-MAIL NOTIFICATIONS
  file { 'Getting kew email notifications sql script':
    ensure  => 'present',
    path    => "${kualicoeus::kc_config_home}/config/kew_email_notifications.sql",
    content => template('kualicoeus/kew_email_notifications.sql.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744';
  } ->
  exec { 'Set KEW related email parameters':
    command     => "bash -c 'export TNS_ADMIN=${::kualicoeus::tnsnames_location}; ${set_kew_paramaters_script}'",
    subscribe   => File["${kualicoeus::kc_config_home}/config/kew_email_notifications.sql"],
    refreshonly => true,
    path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }
}
