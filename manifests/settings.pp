#
# Class to manage settings of Kuali Coeus.
#

class kualicoeus::settings {
  # ## packages needed
  $install_pkgs            = ['curl', 'wget', 'unzip']

  # ## mysql settings
  $root_pw                 = 'strongpassword'
  $username                = 'username'
  $password                = 'password'
  $database                = 'kuali'
  $hostname                = 'localhost'

  # ## MySQL Connector
  $connector_url           = 'http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.33/mysql-connector-java-5.1.33.jar'
  $connector_filename      = 'mysql-connector-java-5.1.33.jar'

  # ## tomcat settings
  $catalina_base           = '/opt/apache-tomcat/tomcat6'
  $tomcat_source_url       = 'http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.39/bin/apache-tomcat-6.0.39.tar.gz'
  $tomcat_file_name        = 'apache-tomcat-6.0.39.tar.gz'
  $tomcat_extract_command  = "tar zxvf ${tomcat_file_name} -C ${catalina_base} --strip-components=1"
  $tomcat_stop             = "bash ${catalina_base}/bin/shutdown.sh -force"
  $tomcat_start            = "bash ${catalina_base}/bin/startup.sh"
  $tomcat_restart          = "bash ${catalina_base}/bin/shutdown.sh -force; bash ${catalina_base}/bin/startup.sh"

  # ## kuali coeus settings
  $kc_coeus_folder         = '/opt/kuali_coeus'
  $kc_config_home          = '/opt/kuali/main/dev'
  $kc_version              = '5.2.1'
  $kc_source               = 'http://downloads.kc.kuali.org/5.0/kc-release-5_2_1.zip'
  $kc_release_file         = 'kc-release-5_2_1.zip'
  $kc_install_folder       = "${kc_coeus_folder}/db_scripts/main"
  $kc_install_script       = 'puppet:///modules/kuali/J_KC_Install.sh'
  $kc_create_folders       = "mkdir -p ${kc_coeus_folder} ${kc_config_home}"
  $kc_extract_release_file = "unzip ${kc_coeus_folder}/${kc_release_file} -d ${kc_coeus_folder}"
  $kc_deploy_war_cmd       = "${tomcat_stop}; cp ${kc_coeus_folder}/binary/kc-ptd.war ${catalina_base}/webapps/kc-dev.war; ${tomcat_start}"

  # ## For the kc-config.xml file
  $kc_application_host     = $::ipaddress
  $kc_http_port            = '8080'
}
