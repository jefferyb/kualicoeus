#
# Turning off the firewall for easy testing...
#
# For more information to configure your firewall using puppetlabs/firewall,
# visit https://forge.puppetlabs.com/puppetlabs/firewall
#
class kualicoeus::configure_firewall {
  class { 'firewall': ensure => stopped, }

}
