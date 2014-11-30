#
# Class to manage downloads of files used by the kualicoeus module
#

class kualicoeus::config::download {
  require ::kualicoeus::config::folders

  staging::deploy { $kualicoeus::kc_release_file:
    source  => $kualicoeus::kc_download_link,
    target  => $kualicoeus::kc_source_folder,
    creates => "${kualicoeus::kc_source_folder}/quickstart_guide.txt",
  }
}
