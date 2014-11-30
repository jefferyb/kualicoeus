#
# To manage Packages.
#

class kualicoeus::config::packages {
  package { $kualicoeus::settings::install_pkgs: ensure => installed, }
}
