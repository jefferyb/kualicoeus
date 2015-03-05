# == Class: kualicoeus::firewall
#
# Turning off the firewall for easy testing...
#
# For more information to configure your firewall using puppetlabs/firewall,
# visit https://forge.puppetlabs.com/puppetlabs/firewall
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::firewall {
  if $::kualicoeus::deactivate_firewall == true {
    class { '::firewall': ensure => stopped, }
  }
}
