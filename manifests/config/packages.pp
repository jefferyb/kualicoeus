# == Class: kualicoeus::config::packages
#
# To manage Packages.
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::config::packages {
  package { $kualicoeus::settings::install_pkgs: ensure => installed, }
}
