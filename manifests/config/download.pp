# == Class: kualicoeus::config::download
#
# Class to manage downloads of files used by the kualicoeus module
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::config::download {
  require ::kualicoeus::config::folders

  staging::deploy { $kualicoeus::_kc_release_file:
    source  => $kualicoeus::_kc_download_link,
    target  => $kualicoeus::kc_source_folder,
    creates => "${kualicoeus::kc_source_folder}/binary/kc-ptd.war",
  }
}
