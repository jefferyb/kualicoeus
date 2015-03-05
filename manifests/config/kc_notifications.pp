# == Class: kualicoeus::config::kc_notifications
#
# Class to manage KC-GEN | kc e-mail notifications
#
# ####**kc_notifications settings:**
#
# #####[*database_type*]
#   - Set this to either 'MYSQL' or 'ORACLE'.
#     - Default: database_type => 'MYSQL',
#
# #####[*kc_email_notifications*]
#   - Enables email notifications to be sent
#     - Default: kc_upgrade_version  => undef,
#
# #####[*kc_email_notification_from_address*]
#   - KC Email Service uses this param to set the default from address for sending email notifications
#     - Default: kc_email_notification_from_address => undef,
#
# #####[*kc_email_notification_test_enabled*]
#   - Set email notifications to TEST MODE
#     - Default: kc_email_notification_test_enabled => undef,
#
# #####[*kc_email_notification_test_address*]
#   - Email notifications will be sent to this id if EMAIL_NOTIFICATION_TEST_ENABLED ($kc_email_notification_test_enabled) set to Y
#     - Default: kc_email_notification_test_address => undef,
#
# === Examples
#
#  class { 'kualicoeus::config::kc_notifications':
#    database_type                      => 'ORACLE',
#    kc_email_notifications             => 'Y',
#    kc_email_notification_from_address => 'kc-email-notif@example.com',
#    kc_email_notification_test_enabled => 'Y',
#    kc_email_notification_test_address => 'admin@example.com',
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

class kualicoeus::config::kc_notifications (
  # KC-GEN | KC related email parameters
  $database_type = $kualicoeus::database_type,
  $kc_email_notifications, # Enables email notifications to be sent
  $kc_email_notification_from_address, # KC Email Service uses this param to set the default from address for sending email notifications
  $kc_email_notification_test_enabled, # Set email notifications to TEST MODE
  $kc_email_notification_test_address, # Email notifications will be sent to this id if EMAIL_NOTIFICATION_TEST_ENABLED ($kc_email_notification_test_enabled) set to Y
  ) {
  if $database_type == 'ORACLE' {
    $set_kc_paramaters_script = "sqlplus ${::kualicoeus::_datasource_username}/${::kualicoeus::_datasource_password}@${::kualicoeus::oracle_kc_install_dbsvrnm} < ${kualicoeus::kc_config_home}/config/kc_email_notifications.sql"
  } elsif $database_type == 'MYSQL' {
    $set_kc_paramaters_script = "mysql -u ${::kualicoeus::_datasource_username} -p${::kualicoeus::_datasource_password} ${::kualicoeus::mysql_kc_install_dbsvrnm} < ${kualicoeus::kc_config_home}/config/kc_email_notifications.sql"
  } else {
    fail("Database ${database_type} is not supported yet. Only 'MYSQL' and 'ORACLE' are supported")
  }

  if $kc_email_notifications == undef {
    fail("Please set 'kc_email_notifications'. e.g class { 'kualicoeus::config::kc_notifications': kc_email_notifications => 'Y' }")
  }

  if $kc_email_notification_from_address == undef {
    fail("Please set 'kc_email_notification_from_address'. e.g class { 'kualicoeus::config::kc_notifications': kc_email_notification_from_address => 'kc-email-notif@example.com' }"
    )
  }

  if $kc_email_notification_test_enabled == undef {
    fail("Please set 'kc_email_notification_test_enabled'. e.g class { 'kualicoeus::config::kc_notifications': kc_email_notification_test_enabled => 'Y' }"
    )
  }

  if $kc_email_notification_test_address == undef {
    fail("Please set 'kc_email_notification_test_address'. e.g class { 'kualicoeus::config::kc_notifications': kc_email_notification_test_address => 'admin@example.com' }"
    )
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
  exec { "Setting KC email notifications parameters in your ${database_type} database":
    command     => "bash -c 'export TNS_ADMIN=${::kualicoeus::tnsnames_location}; ${set_kc_paramaters_script}'",
    subscribe   => File["${kualicoeus::kc_config_home}/config/kc_email_notifications.sql"],
    refreshonly => true,
    path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }
}
