#
# Class to manage settings of Kuali Coeus.
#

class kualicoeus::settings {
  # ## packages needed
  $install_pkgs = ['curl', 'wget', 'unzip']

  # For KC_Install.sh
  $kc_install_mode = 'BUNDLE' # BUNDLE EMBED
  $kc_install_dbtype = 'MYSQL' # ORACLE MYSQL
  $kc_install_version = 'NEW' # NEW 3.1.1 5.0 5.0.1 5.1 5.1.1 5.2
  $kc_install_un = 'username'
  $kc_install_pw = 'password'
  $kc_install_DBSvrNm = 'kuali'
  $kc_install_demo = false

  # ## For the kc-config.xml file
  $kc_app_http_scheme = 'http'
  $kc_application_host = $::ipaddress
  $kc_http_port = '8080'

  # ## mysql settings
  $mysql_root_pw = 'strongpassword'
  $username = $::kualicoeus::kc_install_un
  $password = $::kualicoeus::kc_install_pw
  $database = $::kualicoeus::kc_install_DBSvrNm
  $hostname = 'localhost'

  # TO RESOLVE PUPPETLABS-MYSQL MODULE ON CENTOS 7 (I might be wrong, but in current version, 2.3.1, it trys to install mysql
  # instead of mariadb)
  # My little solution for now...
  $osver = split($::operatingsystemrelease, '[.]')

  case $::osfamily {
    'RedHat' : {
      case $::operatingsystem {
        'Fedora'            : {
          if is_integer($::operatingsystemrelease) and $::operatingsystemrelease >= 19 or $::operatingsystemrelease == 'Rawhide' {
            $mysql_package_name = 'mariadb-server'
            $mysql_service_name = 'mariadb'
            $mysql_config_file = '/etc/my.cnf'
            $mysql_client_package_name = 'mariadb'
          } else {
            $mysql_package_name = 'mysql-server'
            $mysql_service_name = 'mysqld'
            $mysql_config_file = '/etc/my.cnf'
          }
        }
        /^(RedHat|CentOS)$/ : {
          if $osver[0] >= '7' {
            $mysql_package_name = 'mariadb-server'
            $mysql_service_name = 'mariadb'
            $mysql_config_file = '/etc/my.cnf'
            $mysql_client_package_name = 'mariadb'
          } else {
            $mysql_package_name = 'mysql-server'
            $mysql_service_name = 'mysqld'
            $mysql_config_file = '/etc/my.cnf'
            $mysql_client_package_name = 'mysql'
          }
        }
        default             : {
          $mysql_package_name = 'mysql-server'
          $mysql_service_name = 'mysqld'
        }
      }
    }
  }

  # ## MySQL Connector
  $connector_filename = 'mysql-connector-java-5.1.9.jar'
  $connector_url = 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.9/mysql-connector-java-5.1.9.jar'

  # ## tomcat settings
  $catalina_base = '/opt/apache-tomcat/tomcat6'
  $tomcat_file_name = 'apache-tomcat-6.0.41.tar.gz'
  $tomcat_source_url = 'http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.41/bin/apache-tomcat-6.0.41.tar.gz'

  # ## kuali coeus settings
  $kc_source_folder = '/opt/kuali/source/5.2.1'
  $kc_config_home = '/opt/kuali/main/dev'
  $kc_release_file = 'kc-release-5_2_1.zip'
  $kc_download_link = 'http://downloads.kc.kuali.org/5.0/kc-release-5_2_1.zip'
  $kc_war_name = 'kc-dev.war'
  $kc_war_ensure = 'present'

}
