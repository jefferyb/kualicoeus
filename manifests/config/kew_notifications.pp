# == Class: kualicoeus::config::kew_notifications
#
# Class to manage KR-WKFLW | kew e-mail notifications
#
# ####**kew_notifications settings:**
#
# #####[*database_type*]
#   - Set this to either 'MYSQL' or 'ORACLE'.
#     - Default: database_type => 'MYSQL',
#
# #####[*kew_email_notifications*]
#   - Enables email notifications to be sent
#     - Default: kew_email_notifications  => undef,
#
# #####[*kew_from_address*]
#   - Default from email address for notifications
#     - Default: kew_from_address => undef,
#
# #####[*kew_email_notification_test_address*]
#   - Default email address used for testing
#     - Default: kew_email_notification_test_address => undef,
#
# === Examples
#
#  class { 'kualicoeus::config::kew_notifications':
#    database_type                       => 'ORACLE',
#    kew_email_notifications             => 'Y',
#    kew_from_address                    => 'kew-email-notif@example.com',
#    kew_email_notification_test_address => 'admin@example.com',
#  }
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::config::kew_notifications (
  # KR-WKFLW | KEW related email parameters
  $kew_email_notifications,
  $kew_from_address, # Default from email address for notifications
  $kew_email_notification_test_address, # Default email address used for testing
  $database_type = $kualicoeus::database_type,) {
    
  if $database_type == 'ORACLE' {
    $set_kew_paramaters_script = "sqlplus ${::kualicoeus::_datasource_username}/${::kualicoeus::_datasource_password}@${::kualicoeus::oracle_kc_install_dbsvrnm} < ${kualicoeus::kc_config_home}/config/kew_email_notifications.sql"
  } elsif $database_type == 'MYSQL' {
    $set_kew_paramaters_script = "mysql -u ${::kualicoeus::_datasource_username} -p${::kualicoeus::_datasource_password} ${::kualicoeus::mysql_kc_install_dbsvrnm} < ${kualicoeus::kc_config_home}/config/kew_email_notifications.sql"
  } else {
    fail("Database ${database_type} is not supported yet. Only 'MYSQL' and 'ORACLE' are supported")
  }

  if $kew_email_notifications == undef {
    fail("Please set 'kew_email_notifications'. e.g class { 'kualicoeus::config::kew_notifications': kew_email_notifications => 'Y' }"
    )
  }

  if $kew_from_address == undef {
    fail("Please set 'kew_from_address'. e.g class { 'kualicoeus::config::kew_notifications': kew_from_address => 'kew-email-notif@example.com' }"
    )
  }

  if $kew_email_notification_test_address == undef {
    fail("Please set 'kew_email_notification_test_address'. e.g class { 'kualicoeus::config::kew_notifications': kew_email_notification_test_address => 'admin@example.com' }"
    )
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
  exec { "Setting KEW email notifications parameters in your ${database_type} database":
    command     => "bash -c 'export TNS_ADMIN=${::kualicoeus::tnsnames_location}; ${set_kew_paramaters_script}'",
    subscribe   => File["${kualicoeus::kc_config_home}/config/kew_email_notifications.sql"],
    refreshonly => true,
    path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }
}
