# == Class: kualicoeus::config::database
#
# Class to setup the database used by the kualicoeus module
#
# ####**database settings:**
#
# #####[*setup_kuali_upgrade*]
#   - Set this to true to upgrade the database.
#     - Default: setup_kuali_upgrade => false,
#
# #####[*kc_upgrade_version*]
#   - Set the upgrade version number.e.g. kc_upgrade_version => '5.2.1'
#     - Default: kc_upgrade_version  => undef,
#
# #####[*kc_upgrade_file*]
#   - Set the upgrade file name, e.g kc_upgrade_file => 'kc-release-5_2_1.zip',
#     - Default: kc_upgrade_file => undef,
#
# #####[*kc_upgrade_dl_link*]
#   - Set the link where to download the upgrade file name, e.g kc_upgrade_file =>
#   'http://downloads.kc.kuali.org/5.0/kc-release-5_2_1.zip',
#     - Default: kc_upgrade_dl_link => undef,
#
# ####**KC Database settings:**
#
# #####[*kc_version*]
#   - Set the kc version you're running. If you do an upgrade, make sure to set this to the upgraded version after the upgrade is
#   done.
#     - Default: kc_version => '5.2.1',
#
# #####[*upgrade_my_spy_file_source*]
#   - Set the location of your own spy.properties config file
#     - Default: upgrade_my_spy_file_source => undef,
#     - e.g : upgrade_my_spy_file_source => 'puppet:///modules/kualicoeus/my_spy.properties'
#
# #####[*upgrade_my_spy_file_path*]
#   - Set where you want put your own spy.properties config file. If you set `upgrade_catalina_home`, you should also set
#   `upgrade_my_spy_file_path`
#     - Default location: "${kualicoeus::catalina_base}/conf/spy.properties"
#
# #####[*upgrade_autoflush*]
#   - For flushing per statement
#     - Default: upgrade_autoflush => true,
#
# #####[*upgrade_dateformat*]
#   - Sets the date format using Java's SimpleDateFormat routine.
#     - Default: upgrade_dateformat => 'MM-dd-yy HH:mm:ss:SS',
#
# #####[*upgrade_stacktrace*]
#   - Prints a stack trace for every statement logged
#     - Default: upgrade_stacktrace => false,
#
# #####[*upgrade_stacktraceclass*]
#   - If upgrade_stacktrace=>true, specifies the stack trace to print
#     - Default: upgrade_stacktraceclass => '',
#
# #####[*upgrade_logfile*]
#   - Name of logfile to use. If you set `upgrade_catalina_home`, you may want to set `upgrade_logfile` too
#     - Default: ${::kualicoeus::catalina_base}/logs/upgrade_sql.log,
#
# #####[*upgrade_logMessageFormat*]
#   - Class to use for formatting log messages
#     - Default: upgrade_logMessageFormat => 'com.upgrade.engine.spy.appender.MultiLineFormat',
#
#
# === Examples
#
#  class { 'kualicoeus':
#    upgrade_driver_name => 'upgrade-2.1.2.jar',
#    upgrade_driver_url  => 'http://mirrors.ibiblio.org/maven2/upgrade/upgrade/2.1.2/upgrade-2.1.2.jar',
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

class kualicoeus::config::database {
  if $kualicoeus::setup_kuali_upgrade {
    if $kualicoeus::_kc_install_version == 'NEW' {
      fail("Setting kc_upgrade_version => 'NEW' will create a new database")
    } elsif versioncmp($kualicoeus::kc_upgrade_version, $kualicoeus::_kc_version) == 0 {
      fail("This version, ${kualicoeus::kc_upgrade_version}, is already installed. If not, check your 'kc_version' and make sure it's set to the current installed version.")
    } elsif versioncmp($kualicoeus::kc_upgrade_version, $kualicoeus::_kc_version) < 0 {
      fail("The version you're trying to upgrade, ${kualicoeus::kc_upgrade_version}, is lower than the current version, ${kualicoeus::_kc_version} "
      )
    } else {
      require kualicoeus::config::download
      file {
        "${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install.sh":
          ensure  => 'present',
          content => template("kualicoeus/J_KC_Install.${::kualicoeus::kc_upgrade_version}.sh.erb"),
          require => Staging::Deploy[$kualicoeus::_kc_release_file],
          owner   => 'root',
          group   => 'root',
          mode    => '0744';

        "${kualicoeus::kc_source_folder}/db_scripts/main/LOGS":
          ensure => 'directory',
          owner  => 'root',
          group  => 'root';

        "${kualicoeus::kc_source_folder}/db_scripts/main/LOGS/get_sql_errors":
          ensure  => 'present',
          content => template("kualicoeus/get_sql_errors.erb"),
          require => [Staging::Deploy[$kualicoeus::_kc_release_file], File["${kualicoeus::kc_source_folder}/db_scripts/main/LOGS"]],
          owner   => 'root',
          group   => 'root',
          mode    => '0744';
      } ->
      exec { 'Run KC_Config Script':
        cwd     => "${kualicoeus::kc_source_folder}/db_scripts/main",
        command => "bash -c './J_KC_Install.sh' && echo ${::kualicoeus::kc_upgrade_version} > ${::kualicoeus::kc_config_home}/config/Current_${kualicoeus::database_type}_DB_Version",
        unless  => "grep ${kualicoeus::kc_upgrade_version} ${::kualicoeus::kc_config_home}/config/Current_${kualicoeus::database_type}_DB_Version 2>/dev/null",
        notify  => Tomcat::Service['default'],
        require => Staging::Deploy[$kualicoeus::_kc_release_file],
        path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
      }

      if $kualicoeus::send_emails {
        exec { 'Checking Logs for Errors':
          cwd       => "${kualicoeus::kc_source_folder}/db_scripts/main/LOGS",
          command   => "bash -c './get_sql_errors' && echo 'Check the attach files to for any errors' | mail -s 'Upgrade Logs' ${::kualicoeus::email_address} -a CURRENT_UPGRADE_ERRORS",
          subscribe => Exec['Run KC_Config Script'],
          require   => Exec['Run KC_Config Script'],
          path      => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
        }

        exec { 'Sending a reminder to ingest XML files':
          cwd       => "${kualicoeus::kc_source_folder}/db_scripts/main",
          command   => "echo 'Please remember to ingest the XML files. I have attached the zip files from the release file for you. You may need to modify them if necessary.' | mail -s 'Ingest the XMLs' ${::kualicoeus::email_address} -a Rice-KEW.zip -a Full-KC-KEW.zip",
          subscribe => Exec['Run KC_Config Script'],
          require   => Exec['Run KC_Config Script'],
          path      => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
        }
      }
    }
  } else {
    if $kualicoeus::setup_database == true {
      require kualicoeus::config::download

      if $kualicoeus::database_type == 'ORACLE' {
        require ::kualicoeus::oracle
      } elsif $kualicoeus::database_type == 'MYSQL' {
        require ::kualicoeus::mysql
      } else {
        fail("Database ${kualicoeus::database_type} is not supported yet. Only 'MYSQL' and 'ORACLE' are supported")
      }

      if $kualicoeus::kc_install_mode == 'EMBED' {
        fail('******* EMBED MODE HAS NOT BEEN IMPLEMENTED YET... *******')
      } else {
        file {
          "${kualicoeus::kc_source_folder}/db_scripts/main/J_KC_Install.sh":
            ensure  => 'present',
            content => template("kualicoeus/J_KC_Install.${::kualicoeus::_kc_version}.sh.erb"),
            require => Staging::Deploy[$kualicoeus::_kc_release_file],
            owner   => 'root',
            group   => 'root',
            mode    => '0744';

          "${kualicoeus::kc_source_folder}/db_scripts/main/LOGS":
            ensure => 'directory',
            owner  => 'root',
            group  => 'root';

          "${kualicoeus::kc_source_folder}/db_scripts/main/LOGS/get_sql_errors":
            ensure  => 'present',
            content => template("kualicoeus/get_sql_errors.erb"),
            require => [
              Staging::Deploy[$kualicoeus::_kc_release_file],
              File["${kualicoeus::kc_source_folder}/db_scripts/main/LOGS"]],
            owner   => 'root',
            group   => 'root',
            mode    => '0744';
        } ->
        exec { 'Run KC_Config Script':
          cwd     => "${kualicoeus::kc_source_folder}/db_scripts/main",
          command => "bash -c './J_KC_Install.sh' && echo ${::kualicoeus::_kc_version} > ${::kualicoeus::kc_config_home}/config/Current_${kualicoeus::database_type}_DB_Version",
          unless  => "grep ${kualicoeus::_kc_version} ${::kualicoeus::kc_config_home}/config/Current_${kualicoeus::database_type}_DB_Version 2>/dev/null",
          notify  => Tomcat::Service['default'],
          require => Staging::Deploy[$kualicoeus::_kc_release_file],
          path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
        }
      }
    }
  }
}