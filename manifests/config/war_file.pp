#
# Class to manage war file used by the kualicoeus module
#

class kualicoeus::config::war_file {
  if $kualicoeus::setup_tomcat == true {
    tomcat::war { $::kualicoeus::kc_war_name:
      catalina_base => $::kualicoeus::catalina_base,
      war_ensure    => $::kualicoeus::kc_war_ensure,
      war_source    => $::kualicoeus::kc_war_source,
    }
  }
}
