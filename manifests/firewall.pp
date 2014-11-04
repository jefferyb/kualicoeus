#
# Turning off the firewall for easy testing...
#
# For more information to configure your firewall using puppetlabs/firewall,
# visit https://forge.puppetlabs.com/puppetlabs/firewall
#
class kualicoeus::firewall {
  # Since puppetlabs/firewall is not turning off/managing Centos 7:
  case $::operatingsystem {
    /^(RedHat|CentOS)$/ : {
      if $::kualicoeus::settings::osver[0] >= '7' {
        service { 'firewalld':
          ensure => stopped,
          enable => false,
        }
      } else {
        class { '::firewall': ensure => stopped, }
      }
    }
    default             : {
      class { '::firewall': ensure => stopped, }
    }
  }
}
