# == Class: kualicoeus::shibboleth
#
# This class manages shibboleth for kualicoeus using minimal settings.
# Using jefferyb/shibboleth module to install & configure shibboleth
# If you would like to configure/dig a bit more deeper, check jefferyb-shibboleth
# for more at https://forge.puppetlabs.com/jefferyb/shibboleth
#
#        P.S setup_shibboleth is set to false by default, so if want to use
#  the jefferyb/shibboleth module on its own, it will have more settings to play with.
#
# If you do find some settings that I should add here to be part of this class,
# let me know and I'll see about adding them here...
#
# === Authors
#
# Jeffery Bagirimvano <jeffery.rukundo@gmail.com>
#
# === Copyright
#
# Copyright 2014 Jeffery B.
#

class kualicoeus::shibboleth {
  if $kualicoeus::setup_shibboleth {
    if $kualicoeus::shib_provider_uri == undef {
      fail("Please set your Metadata provider url, 'shib_provider_uri'. e.g class { 'kualicoeus': shib_provider_uri => 'http://www.testshib.org/metadata/testshib-providers.xml' }"
      )
    }

    if $kualicoeus::shib_discoveryProtocol == 'idpURL' {
      if $kualicoeus::shib_idpURL == undef {
        fail("Please set your idpURL, 'shib_idpURL'. e.g class { 'kualicoeus': shib_idpURL => 'https://idp.testshib.org/idp/shibboleth' }"
        )
      }

      if $kualicoeus::shib_session_location == undef {
        fail("Please set your session_location, 'shib_session_location'. This should be the same as your 'app.context.name' in your kc-config.xml file. e.g class { 'kualicoeus': shib_session_location => 'kc-dev' }"
        )
      }

      class { '::shibboleth':
        # Shib Certificates
        manage_shib_certificate  => $kualicoeus::shib_manage_shib_certificate,
        create_shib_cert         => $kualicoeus::shib_create_shib_cert,
        shib_key_source          => $kualicoeus::shib_key_source,
        shib_cert_source         => $kualicoeus::shib_cert_source,
        # mod_ssl Certificates
        manage_ssl_certificate   => $kualicoeus::shib_manage_ssl_certificate,
        create_ssl_cert          => $kualicoeus::shib_create_ssl_cert,
        sslCertificateChainFile  => $kualicoeus::shib_sslCertificateChainFile,
        key_cert_source          => $kualicoeus::shib_key_cert_source,
        csr_cert_source          => $kualicoeus::shib_csr_cert_source,
        incommon_cert_source     => $kualicoeus::shib_incommon_cert_source,
        sslSessionCacheTimeout   => $kualicoeus::shib_sslSessionCacheTimeout,
        # Set discoveryProtocol SSO Attributes
        idpURL                   => $kualicoeus::shib_idpURL,
        # Session location to secure
        session_location         => $kualicoeus::shib_session_location,
        # Metadata
        provider_uri             => $kualicoeus::shib_provider_uri,
        backingFileName          => $kualicoeus::shib_backingFileName,
        provider_reload_interval => $kualicoeus::shib_provider_reload_interval,
      }
    }

    if $kualicoeus::shib_discoveryProtocol == 'discoveryURL' {
      if $kualicoeus::shib_discoveryURL == undef {
        fail("Please set your discoveryURL, 'shib_discoveryURL'. e.g class { 'kualicoeus': shib_discoveryURL => 'https://example.federation.org/ds/DS' }"
        )
      }

      class { '::shibboleth':
        # Shib Certificates
        manage_shib_certificate  => $kualicoeus::shib_manage_shib_certificate,
        create_shib_cert         => $kualicoeus::shib_create_shib_cert,
        shib_key_source          => $kualicoeus::shib_key_source,
        shib_cert_source         => $kualicoeus::shib_cert_source,
        # mod_ssl Certificates
        manage_ssl_certificate   => $kualicoeus::shib_manage_ssl_certificate,
        create_ssl_cert          => $kualicoeus::shib_create_ssl_cert,
        sslCertificateChainFile  => $kualicoeus::shib_sslCertificateChainFile,
        key_cert_source          => $kualicoeus::shib_key_cert_source,
        csr_cert_source          => $kualicoeus::shib_csr_cert_source,
        incommon_cert_source     => $kualicoeus::shib_incommon_cert_source,
        sslSessionCacheTimeout   => $kualicoeus::shib_sslSessionCacheTimeout,
        # Set discoveryProtocol SSO Attributes
        discoveryURL             => $kualicoeus::shib_discoveryURL,
        # Session location to secure
        session_location         => $kualicoeus::shib_session_location,
        # Metadata
        provider_uri             => $kualicoeus::shib_provider_uri,
        backingFileName          => $kualicoeus::shib_backingFileName,
        provider_reload_interval => $kualicoeus::shib_provider_reload_interval,
      }
    }
  }
}