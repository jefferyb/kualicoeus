# == Class: kualicoeus::config::p6spy
#
# Class to setup p6spy used by the kualicoeus module
#
# ####**p6spy settings:**
#
# #####[*p6spy_driver_name*]
#   - Set the name of the driver.
#     - Default: p6spy_driver_name => 'p6spy-2.1.2.jar',
#
# #####[*p6spy_driver_url*]
#   - Set the url, where to download the driver.
#     - Default: p6spy_driver_url  => 'http://mirrors.ibiblio.org/maven2/p6spy/p6spy/2.1.2/p6spy-2.1.2.jar',
#
# #####[*p6spy_catalina_home*]
#   - Tell p6spy where tomcat is located. It's useful if you already have tomcat setup (if the kualicoeus module didn't set it up
#   for you).
#     If you set `p6spy_catalina_home`, you may want to set `p6spy_my_spy_file_path` and `p6spy_logfile` too
#     - Default: p6spy_catalina_home => undef,
#
# ####**spy.properties settings:**
#
# #####[*p6spy_my_spy_file*]
#   - Set p6spy_my_spy_file to true to use your own spy.properties config file
#     - Default: p6spy_my_spy_file => false,
#
# #####[*p6spy_my_spy_file_source*]
#   - Set the location of your own spy.properties config file
#     - Default: p6spy_my_spy_file_source => undef,
#     - e.g : p6spy_my_spy_file_source => 'puppet:///modules/kualicoeus/my_spy.properties'
#
# #####[*p6spy_my_spy_file_path*]
#   - Set where you want put your own spy.properties config file. If you set `p6spy_catalina_home`, you should also set
#   `p6spy_my_spy_file_path`
#     - Default location: "${kualicoeus::catalina_base}/conf/spy.properties"
#
# #####[*p6spy_autoflush*]
#   - For flushing per statement
#     - Default: p6spy_autoflush => true,
#
# #####[*p6spy_dateformat*]
#   - Sets the date format using Java's SimpleDateFormat routine.
#     - Default: p6spy_dateformat => 'MM-dd-yy HH:mm:ss:SS',
#
# #####[*p6spy_stacktrace*]
#   - Prints a stack trace for every statement logged
#     - Default: p6spy_stacktrace => false,
#
# #####[*p6spy_stacktraceclass*]
#   - If p6spy_stacktrace=>true, specifies the stack trace to print
#     - Default: p6spy_stacktraceclass => '',
#
# #####[*p6spy_logfile*]
#   - Name of logfile to use. If you set `p6spy_catalina_home`, you may want to set `p6spy_logfile` too
#     - Default: ${::kualicoeus::catalina_base}/logs/p6spy_sql.log,
#
# #####[*p6spy_logMessageFormat*]
#   - Class to use for formatting log messages
#     - Default: p6spy_logMessageFormat => 'com.p6spy.engine.spy.appender.MultiLineFormat',
#
#
# === Examples
#
#  class { 'kualicoeus':
#    p6spy_driver_name => 'p6spy-2.1.2.jar',
#    p6spy_driver_url  => 'http://mirrors.ibiblio.org/maven2/p6spy/p6spy/2.1.2/p6spy-2.1.2.jar',
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
class kualicoeus::config::p6spy {
  if $kualicoeus::setup_p6spy {
    staging::file { $kualicoeus::p6spy_driver_name:
      source => $kualicoeus::p6spy_driver_url,
      target => "${kualicoeus::_catalina_base}/lib/${kualicoeus::p6spy_driver_name}",
    }

    if $kualicoeus::p6spy_my_spy_file {
      file { 'My Own spy.properties File':
        ensure => 'present',
        path   => $kualicoeus::_p6spy_my_spy_file_path,
        source => $kualicoeus::p6spy_my_spy_file_source,
        notify => Tomcat::Service['default'],
        mode   => '0664';
      }
    } else {
      file { 'spy.properties File':
        ensure  => 'present',
        path    => "${kualicoeus::_catalina_base}/conf/spy.properties",
        content => template('kualicoeus/spy.properties.erb'),
        notify  => Tomcat::Service['default'],
        mode    => '0664';
      }
    }
  } else {
    file {
      'Remove p6spy Driver File':
        ensure => 'absent',
        notify => Exec["Rename ${kualicoeus::_p6spy_logfile}"],
        path   => "${kualicoeus::_catalina_base}/lib/${kualicoeus::p6spy_driver_name}";

      'Remove spy.properties File':
        ensure => 'absent',
        notify => Tomcat::Service['default'],
        path   => "${kualicoeus::_catalina_base}/conf/spy.properties";
    }

    exec { "Rename ${kualicoeus::_p6spy_logfile}":
      command     => "mv ${kualicoeus::_p6spy_logfile} ${kualicoeus::_p6spy_logfile}.`date +%Y-%m-%d_%H:%M:%S`",
      refreshonly => true,
      path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];
    }
  }
}
