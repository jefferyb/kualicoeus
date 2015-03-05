
# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
class { 'kualicoeus':
  # Shibboleth settings:
  setup_shibboleth             => true,
  shib_sslSessionCacheTimeout  => '1200',
  shib_create_ssl_cert         => false,
  shib_sslCertificateChainFile => true,
  shib_idpURL                  => 'https://idp.testshib.org/idp/shibboleth',
  shib_provider_uri            => 'http://www.testshib.org/metadata/testshib-providers.xml',
  shib_backingFileName         => 'testshib-idp-metadata.xml',
}
