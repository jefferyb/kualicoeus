#
# Class to manage folders used by the kualicoeus module
#

class kualicoeus::config::folders {
  exec { 'Create Source Folder':
    command => "mkdir -p ${kualicoeus::kc_source_folder}",
    creates => $kualicoeus::kc_source_folder,
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  } ->
  exec { 'Create KC Config Folder':
    command => "mkdir -p ${kualicoeus::kc_config_home}",
    creates => $kualicoeus::kc_config_home,
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  } ->
  file { 'Create folder for config files':
    ensure => 'directory',
    path   => "${kualicoeus::kc_config_home}/config",
  }
}