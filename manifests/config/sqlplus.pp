# == Class: kualicoeus::config::sqlplus
#
# Class to manage sqlplus used by the kualicoeus module
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::config::sqlplus (
  $sqlplus_user_home   = '/root',
  $sqlplus_file        = 'oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm',
  $sqlplus_link        = 'ftp://bo.mirror.garr.it/pub/1/slc/centos/7.0.1406/cernonly/x86_64/Packages/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm',
  $oracle_instantclient12_1_basic      = 'oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm',
  $oracle_instantclient12_1_basic_link = 'ftp://bo.mirror.garr.it/pub/1/slc/centos/7.0.1406/cernonly/x86_64/Packages/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm',
  $oracle_instantclient12_1_devel      = 'oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm',
  $oracle_instantclient12_1_devel_link = 'ftp://bo.mirror.garr.it/pub/1/slc/centos/7.0.1406/cernonly/x86_64/Packages/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm',
  # Settings for tnsnames.ora file
  $oracle_service_name = $kualicoeus::oracle_kc_install_dbsvrnm,
  $oracle_hostname     = $kualicoeus::db_hostname,
  $oracle_port         = $kualicoeus::oracle_datasource_port,
  $tnsnames_location   = $kualicoeus::tnsnames_location,) {

  if $oracle_service_name == undef {
    fail("Please set 'oracle_service_name' in your class { 'kualicoeus::config::sqlplus': }")
  }

  if $oracle_hostname == undef {
    fail("Please set 'oracle_hostname' in your class { 'kualicoeus::config::sqlplus': }")
  }

  if $oracle_port == undef {
    fail("Please set 'oracle_port' in your class { 'kualicoeus::config::sqlplus': }")
  }

  if $tnsnames_location == undef {
    fail("Please set 'tnsnames_location' in your class { 'kualicoeus::config::sqlplus': }")
  }

  #
  # Setup SQL*Plus Client
  #
  exec {
    'Create Oracle Folder':
      cwd     => '/opt/',
      command => 'mkdir -p /opt/oracle',
      creates => '/opt/oracle',
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];

    'Download sqlplus':
      cwd     => '/opt/oracle',
      command => "wget ${sqlplus_link}",
      creates => "/opt/oracle/${sqlplus_file}",
      require => Exec['Create Oracle Folder'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];

    'Download oracle-instantclient12.1-basic':
      cwd     => '/opt/oracle',
      command => "wget ${oracle_instantclient12_1_basic_link}",
      creates => "/opt/oracle/${oracle_instantclient12_1_basic}",
      require => Exec['Create Oracle Folder'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];

    'Download oracle-instantclient12.1-devel':
      cwd     => '/opt/oracle',
      command => "wget ${oracle_instantclient12_1_devel_link}",
      creates => "/opt/oracle/${oracle_instantclient12_1_devel}",
      require => Exec['Create Oracle Folder'],
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];
  }

  case $::operatingsystem {
    /^(RedHat|CentOS|Scientific|OracleLinux)$/ : {
      exec { 'Install sqlplus files':
        cwd     => '/opt/oracle',
        command => "yum install -y ${sqlplus_file} ${oracle_instantclient12_1_basic} ${oracle_instantclient12_1_devel}",
        require => [
          Exec['Download sqlplus'],
          Exec['Download oracle-instantclient12.1-basic'],
          Exec['Download oracle-instantclient12.1-devel'],
          ],
        creates => '/usr/bin/sqlplus64',
        path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];
      } ->
      file { '/usr/bin/sqlplus':
        ensure => 'link',
        target => '/usr/lib/oracle/12.1/client64/bin/sqlplus',
      }
    }
    /^(Ubuntu|Debian)$/ : {
      package {
        'alien':
          ensure => 'present';

        'libaio1':
          ensure => 'present';
      }

      exec { 'Install sqlplus files':
        cwd     => '/opt/oracle',
        command => "alien -i ${sqlplus_file}; alien -i ${oracle_instantclient12_1_basic}; alien -i ${oracle_instantclient12_1_devel}",
        require => [
          Exec['Download sqlplus'],
          Exec['Download oracle-instantclient12.1-basic'],
          Exec['Download oracle-instantclient12.1-devel'],
          ],
        creates => '/usr/bin/sqlplus64',
        path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];
      } ->
      file { '/usr/bin/sqlplus':
        ensure => 'link',
        target => '/usr/lib/oracle/12.1/client64/bin/sqlplus',
      }
    }
    default             : {
      fail('Unrecognized operating system... Let me to see if we can add it...')
    }
  }

  file { '/etc/ld.so.conf.d/oracle.conf':
    ensure  => 'present',
    content => '/usr/lib/oracle/12.1/client64/lib/',
    mode    => '0644',
    require => Exec['Install sqlplus files'],
  } ->
  exec { 'Run the dynamic linker':
    command     => 'ldconfig',
    subscribe   => File['/etc/ld.so.conf.d/oracle.conf'],
    refreshonly => true,
    require     => Exec['Install sqlplus files'],
    path        => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];
  } ->
  file { "${tnsnames_location}/tnsnames.ora":
    ensure  => 'file',
    content => template('kualicoeus/tnsnames.ora.erb'),
    mode    => '0644',
  } ->
  exec { 'TNSNAMES.ORA location':
    command => "echo 'export TNS_ADMIN=${::kualicoeus::tnsnames_location}' >> ${sqlplus_user_home}/.bashrc; bash -c 'source ${sqlplus_user_home}/.bashrc'",
    unless  => "grep -c 'export TNS_ADMIN=${::kualicoeus::tnsnames_location}' ${sqlplus_user_home}/.bashrc",
    require => Exec['Install sqlplus files'],
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'];
  }
}