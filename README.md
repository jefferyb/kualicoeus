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

## Overview

The kualicoeus module enables you to install Kuali Coeus Bundle with MySQL Server.

## Module Description

The kualicoeus module gives you a way to install Kuali Coeus Bundle with MySQL Server, with very minimum settings in the kc-config.xml file.

For now, I just converted the "install_kuali_coeus_bundle" script, https://github.com/jefferyb/install_kuali_coeus_bundle, to a puppet version and will be adding features on it.

## Setup

### What kualicoeus affects

This module will affect:

* Firewall: It will be turned off, for now...
* MySQL: It will add some setting to your my.cnf
* Tomcat: It will install a version 6 of tomcat from source to /opt/apache-tomcat/tomcat6 (default)
* Java: Make sure that java is installed 

### Setup Requirements

pluginsync needs to be enabled on Ubuntu 12.04 LTS

### Beginning with kualicoeus

The simplest way to get Kuali Coeus up and running with the kualicoeus module is to add:

```
  class { "kualicoeus": }
```
in your manifests/site.pp file
 

## Usage
 To install KC_Install_Demo.sh
```
  class { 'kualicoeus': 
    kc_install_demo      => true,
 }
```
 To change where to access the application & port
```
  class { 'kualicoeus': 
    kc_application_host => 'localhost',
    kc_http_port        => '8083',
 }
```
To use your own WAR file:
```
class { 'kualicoeus': 
	kc_war_ensure => 'absent', 
} 
tomcat::war { 'sample.war':
	catalina_base => '/opt/apache-tomcat/tomcat8',
	war_source    => '/opt/apache-tomcat/tomcat8/webapps/docs/appdev/sample/sample.war',
}
```

See below for more settings you can use...

## Reference

Options you can use to configure:
: KC_Install.sh settings:
> **kc_install_mode**     	 - # BUNDLE EMBED 	  	Default: BUNDLE
> **kc_install_dbtype**   	 - # ORACLE MySQL			    Default: MYSQL
> **kc_install_version**	   - # NEW 3.1.1 5.0 5.0.1 5.1 5.1.1 5.2 	Default: NEW
> **kc_install_un**       	   - Change KC Database Username
> **kc_install_pw**       	   - Change KC Database Password
> **kc_install_DBSvrNm**  - Change KC Schema Name
> **kc_install_demo**         - # true | false Default: false - Run KC_Install_Demo.sh script to install demonstration data (Optional)

: kc-config.xml settings:
> **kc_app_http_scheme**		- Change application.http.scheme 		Default: http
> **kc_application_host	**	- Change application.host 				Default: IP address ($::ipaddress) 
> **kc_http_port**			- Change http.port 						Default: 8080

: Kuali Coeus settings:
> **kc_source_folder** - Location where you want your kc source extracted. | Default: /opt/kuali/source
> **kc_config_home** - kc-config.xml's location | Default: /opt/kuali/main/dev
> **kc_release_file** - kc release file name. e.g. kc-release-5_2_1.zip
> **kc_download_link** - kc source url. e.g. http://downloads.kc.kuali.org/5.0/kc-release-5_2_1.zip
> **kc_war_name** - war file's name to be deployed as. | Default: 'kc-ptd.war' using the vanilla .war file
> **kc_war_ensure**	 - Default: 'present' - Set this to 'absent' or 'false' if you want to use your own war file and then use tomcat::war (https://github.com/puppetlabs/puppetlabs-tomcat#i-want-to-deploy-war-files) to deploy/manage you war file. e.g.   
> ```
class { 'kualicoeus': 
	  kc_war_ensure => 'absent', 
} 
tomcat::war { 'sample.war':
      catalina_base => '/opt/apache-tomcat/tomcat8',
      war_source    => '/opt/apache-tomcat/tomcat8/webapps/docs/appdev/sample/sample.war',
}
```

: MySQL settings:
> **mysql_root_pw**			- Set MySQL root password
> **connector_filename** - Connector file name to download, like mysql-connector-java-5.1.9.jar
> **connector_url**  - Connector's url, like http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.9/mysql-connector-java-5.1.9.jar

: tomcat settings:
> **catalina_base** - Change catalina_base location.
> **tomcat_file_name** - tomcat source file name to download. e.g. apache-tomcat-6.0.41.tar.gz
> **tomcat_source_url** - tomcat source url. e.g. http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.41/bin/apache-tomcat-6.0.41.tar.gz

## Limitations

So far, I've tested it on Ubuntu 12.04, 14.04 and a CentOS release 6.5 & 7

## Development

The modules are open projects, and community contributions are essential for keeping them great. So please, if you would like to contribute and make it a whole lot better, please don't hesitate :)
