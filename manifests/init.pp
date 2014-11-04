#
# Class to manage installation and configuration of Kuali Coeus.
#

class kualicoeus (
  # MySQL settings
  $mysql_root_pw       = $::kualicoeus::settings::mysql_root_pw,
  $connector_filename  = $::kualicoeus::settings::connector_filename,
  $connector_url       = $::kualicoeus::settings::connector_url,
  # tomcat Settings
  $catalina_base       = $::kualicoeus::settings::catalina_base,
  $tomcat_file_name    = $::kualicoeus::settings::tomcat_file_name,
  $tomcat_source_url   = $::kualicoeus::settings::tomcat_source_url,
  # Kuali Coeus settings
  $kc_source_folder    = $::kualicoeus::settings::kc_source_folder,
  $kc_config_home      = $::kualicoeus::settings::kc_config_home,
  $kc_release_file     = $::kualicoeus::settings::kc_release_file,
  $kc_download_link    = $::kualicoeus::settings::kc_download_link,
  $kc_war_name         = $::kualicoeus::settings::kc_war_name,
  $kc_war_ensure       = $::kualicoeus::settings::kc_war_ensure,
  # KC_Install.sh settings
  $kc_install_mode     = $::kualicoeus::settings::kc_install_mode,
  $kc_install_dbtype   = $::kualicoeus::settings::kc_install_dbtype,
  $kc_install_version  = $::kualicoeus::settings::kc_install_version,
  $kc_install_un       = $::kualicoeus::settings::kc_install_un,
  $kc_install_pw       = $::kualicoeus::settings::kc_install_pw,
  $kc_install_DBSvrNm  = $::kualicoeus::settings::kc_install_DBSvrNm,
  $kc_install_demo     = $::kualicoeus::settings::kc_install_demo,
  # kc-config.xml settings
  $kc_app_http_scheme  = $::kualicoeus::settings::kc_app_http_scheme,
  $kc_application_host = $::kualicoeus::settings::kc_application_host,
  $kc_http_port        = $::kualicoeus::settings::kc_http_port,) inherits ::kualicoeus::settings {

  include kualicoeus::settings
  require java
  require kualicoeus::packages
  require kualicoeus::firewall
  require kualicoeus::mysql
  require kualicoeus::tomcat
  require kualicoeus::kuali
}
