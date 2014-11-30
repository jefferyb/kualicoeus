#
# Class to manage connector files used by the kualicoeus module
#

class kualicoeus::config::connector {
  if ($kualicoeus::setup_tomcat == true) and ($kualicoeus::database_type == 'MYSQL') {
    staging::file { $::kualicoeus::mysql_connector_filename:
      source => $::kualicoeus::mysql_connector_url,
      target => "${::kualicoeus::catalina_base}/lib/${::kualicoeus::mysql_connector_filename}",
    }
  }

  if ($kualicoeus::setup_tomcat == true) and ($kualicoeus::database_type == 'ORACLE') {
    exec { 'Copy an Oracle Connector':
      command => "cp ${::kualicoeus::oracle_connector_url} ${::kualicoeus::catalina_base}/lib/${::kualicoeus::oracle_connector_filename}",
      creates => "${::kualicoeus::catalina_base}/lib/${::kualicoeus::oracle_connector_filename}",
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];
    }
  }
}
