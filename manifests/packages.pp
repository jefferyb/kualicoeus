#
# To manage Packages.
#

class kualicoeus::packages {
  package {
    $kualicoeus::settings::install_pkgs:
      ensure => installed,
  }
}
