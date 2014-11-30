# kualicoeus

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup - The basics of getting started with kualicoeus](#setup)
    * [What kualicoeus affects](#what-kualicoeus-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kualicoeus](#beginning-with-kualicoeus)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## What's NEW!!!
v. 0.1.3:
  * E-mail notifications - KC & KEW
  * Oracle Database option using Oracle XE 11g using Docker (for testing) 
  * Already have the database setup? Install without setting up the database

## Overview

The kualicoeus module enables you to install Kuali Coeus Bundle with MySQL Server.

## Module Description

The kualicoeus module gives you a way to install Kuali Coeus Bundle with MySQL Server, with very minimum settings in the kc-config.xml file.

For now, I just converted the "install_kuali_coeus_bundle" script, https://github.com/jefferyb/install_kuali_coeus_bundle, to a puppet version and will be adding features on it.

## Setup

### What kualicoeus affects

This module will affect:

* Firewall: It will be turned off. You can choose to leave it. See `deactivate_firewall`
* MySQL: It will add/remove some setting to your my.cnf. You can choose to leave it alone. See `setup_database` 
* Tomcat: By default, it will install a version 6 of tomcat from source to /opt/apache-tomcat/tomcat6. You can choose not to. See `setup_tomcat`


### Setup Requirements

pluginsync needs to be enabled on Ubuntu 12.04 LTS

### Beginning with kualicoeus

The simplest way to get Kuali Coeus up and running with the kualicoeus module is to add:

```puppet
  class { "kualicoeus": }
```
in your manifests/site.pp file
 

## Usage
 To try it on an Oracle XE 11g Database (Using docker: alexeiled/docker-oracle-xe-11g )
```puppet
class { 'kualicoeus': 
    database_type    => 'ORACLE',
 }
```
To change where to access the application & port (e.g if you're running/testing in vagrant). See the kc-config.xml section settings.
```puppet
class { 'kualicoeus': 
  kc_application_host => 'localhost',
  kc_http_port        => '8083',
}
```
By default, kualicoeus module turns off the firewall for easy testing. To leave it as is use `deactivate_firewall`
```puppet
class { 'kualicoeus': 
  deactivate_firewall => false,
}
```
Already have your database setup? Install everything but the database. 
```puppet
class { 'kualicoeus': 
  setup_database => false,
}
```
To turn on/off KEW e-mail notifications
```puppet
class { 'kualicoeus::config::kew_notifications':
    kew_email_notifications             => 'Y',
    kew_from_address                    => 'kew.notifications@dev.example.edu',
    kew_email_notification_test_address => 'root@dev.example.edu',
}
```
To turn on/off KC e-mail notifications
```puppet
class { 'kualicoeus::config::kc_notifications':
    kc_email_notification_from_address => 'kc.notifications@dev.example.edu',
    kc_email_notification_test_enabled => 'Y',
    kc_email_notification_test_address => 'root@dev.example.edu',
}
```
To install KC_Install_Demo.sh
```puppet
class { 'kualicoeus': 
    kc_install_demo      => true,
}
```
To use your own WAR file 
(The kc_war_source can be a local file, puppet:/// file, http, or ftp.):
```puppet
class { 'kualicoeus': 
  kc_war_source => 'puppet:///modules/kualicoeus/kc-dev.war',
}
```
To remove WAR file and directory:
```puppet
class { 'kualicoeus': 
  kc_war_ensure => 'absent', 
} 
```


See below for more settings you can use...

## Reference

## Parameters

Options you can use to configure:

####kualicoeus
#####`deactivate_firewall`
- By default, the module turns off the firewall for easy testing. 
- Options: **'true'**, 'false'
#####`setup_tomcat`
- Choose if you want to install tomcat or not. Like in case you have your own installed and configured
- Options: **'true'**, 'false'
#####`setup_database`
- Choose if you want this module to setup a database or not. You can use `false` in case you have your own setup and configured
- Options: **'true'**, 'false'
#####`database_type` 
- Choose what Database Type you want to use 
- Options: **'MYSQL'**, 'ORACLE'

#### **MySQL settings related:**
#####`mysql_root_pw`
- Set MySQL root password
#####`db_hostname`
- Set your database hostname
#####`mysql_connector_filename` | `oracle_connector_filename`
- Connector file name to download, like mysql-connector-java-5.1.9.jar
#####`mysql_connector_url` | `oracle_connector_url`
- Connector's url, like http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.9/mysql-connector-java-5.1.9.jar

#### **KC_Install.sh settings related:**
#####`kc_install_mode` 
- Options: 'BUNDLE', 'EMBED'  | Default: 'BUNDLE'
#####`kc_install_version` 
- Options: NEW 3.1.1 5.0 5.0.1 5.1 5.1.1 5.2  Default: NEW
#####`mysql_kc_install_un` | `oracle_kc_install_un`
- Change KC Database Username
#####`mysql_kc_install_pw` | `oracle_kc_install_pw`
- Change KC Database Password
#####`mysql_kc_install_dbsvrnm` | `oracle_kc_install_dbsvrnm`
- Change KC Schema Name
#####`kc_install_demo`
- Run KC_Install_Demo.sh script to install demonstration data (Optional) | Options: 'true', 'false' | Default: false

#####`tnsnames_location`
-  tnsnames.ora file location

#### **kc-config.xml settings related:**
#####`kc_config_home`
- kc-config.xml's location | Default: /opt/kuali/main/dev
#####`application_http_scheme`
- Change application.http.scheme | Default: http
#####`application_host`
- Change application.host | Default: $::fqdn 
#####`http_port`
- Change http.port | Default: 8080
#####`environment`
- Change environment | Default: dev
#####`build_version`
- Change build.version | Default: 5.2.1
#####`production_environment_code`
- Change production.environment.code | Default: xyz

#####`oracle_datasource_port`
- Mainly used in the tnsnames.ora file for now...
#####`mysql_datasource_url` | `oracle_datasource_url`
- Change datasource.url 
#####`mysql_datasource_username` | `oracle_datasource_username`
- Change datasource.username 
#####`mysql_datasource_password` | `oracle_datasource_password`
- Change datasource.password
#####`mysql_datasource_ojb_platform` | `oracle_datasource_ojb_platform`
- Change datasource.ojb.platform
#####`oracle_datasource_driver_name`
- Change datasource.driver.name
#####`mail_smtp_host`
- Change mail.smtp.host
#####`mail_smtp_port`
- Change mail.smtp.port
#####`mail_smtp_username`
- Change mail.smtp.username
#####`mail_user_password`
- Change mail.user.password
#####`mail_smtp_auth`
- Change mail.smtp.auth
#####`mail_from`
- Change mail.from
#####`mail_relay_server`
- Change mail.relay.server
#####`kualiexceptionhandleraction_exception_incident_report_service`
- Change KualiExceptionHandlerAction.EXCEPTION_INCIDENT_REPORT_SERVICE
#####`mailmessage_from`
- Change MailMessage.from
#####`kualiexceptionincidentserviceimpl_additionalexceptionnamelist`
- Change KualiExceptionIncidentServiceImpl.additionalExceptionNameList
#####`kualiexceptionincidentserviceimpl_report_mail_list`
- Change KualiExceptionIncidentServiceImpl.REPORT_MAIL_LIST
#####`kr_incident_mailing_list`
- Change kr.incident.mailing.list
#####`mailing_list_batch`
- Change mailing.list.batch
#####`encryption_key`
- Change encryption.key
#####`filter_login_class`
- Change filter.login.class
#####`filtermapping_login_1`
- Change filtermapping.login.1
#####`grants_gov_s2s_host_production`
- Change grants.gov.s2s.host.production
#####`grants_gov_s2s_host_development`
- Change grants.gov.s2s.host.development
#####`grants_gov_s2s_host`
- Change grants.gov.s2s.host
#####`grants_gov_s2s_port`
- Change grants.gov.s2s.port
#####`s2s_keystore_password`
- Change s2s.keystore.password
#####`s2s_keystore_location`
- Change s2s.keystore.location
#####`s2s_truststore_location`
- Change s2s.truststore.location
#####`s2s_truststore_password`
- Change s2s.truststore.password


#### **Kuali Coeus settings related:**
#####`kc_release_file`
- kc release file name. e.g. kc-release-5_2_1.zip
#####`kc_download_link`
- kc source url. e.g. http://downloads.kc.kuali.org/5.0/kc-release-5_2_1.zip
#####`kc_source_folder`
- Location where you want your kc source extracted. | Default: /opt/kuali/source
#####`kc_war_name`
- WAR file's name to be deployed as.
#####`kc_war_source`
- The kc_war_source can be a local file, puppet:/// file, http, or ftp
#####`kc_war_ensure`
- Default: 'present' - Set this to 'absent' or 'false' if you want to delete the war file & folder or not deploy the war file...  


#### **tomcat settings related:**
#####`catalina_base`
- Change catalina_base location.
#####`tomcat_file_name`
- tomcat source file name to download. e.g. apache-tomcat-6.0.41.tar.gz
#####`tomcat_source_url`
- tomcat source url. e.g. http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.41/bin/apache-tomcat-6.0.41.tar.gz

## Limitations

So far, I've tested it on Ubuntu 12.04, 14.04 and a CentOS release 6.5 & 7

## Development

The modules are open projects, and community contributions are essential for keeping them great. So please, if you would like to contribute and make it a whole lot better, please don't hesitate :)
