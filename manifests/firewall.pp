#
# Turning off the firewall for easy testing...
#
# For more information to configure your firewall using puppetlabs/firewall,
# visit https://forge.puppetlabs.com/puppetlabs/firewall
#
class kualicoeus::firewall {
  if $::kualicoeus::deactivate_firewall == true {
    class { '::firewall': ensure => stopped, }
  }
}
