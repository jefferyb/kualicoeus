##2015-03-17 - Release 1.3.7

Added a number of features and fixes to this release. The main ones being:
- Added Shibboleth
- Added P6Spy to log all SQL statement and parameter values before send it to database
- Support to install KC 5.1 - 6.0
- Support to do upgrades

##2014-12-02 - Supported Release 0.1.4

This was just a bug fix, where whenever you set `setup_tomcat => false`, it would complain.

##2014-11-30 - Supported Release 0.1.3

This release adds e-mail notifications, KC & KEW, option to use Oracle Database for testing (using docker) and added more settings to the kc-config.xml file. 

###Features
- Added `setup_tomcat` to choose to choose if you want to setup tomcat or not using this module | Default: 'true'
- Added `database_type` to choose between MySQL and Oracle | Default: 'MysSQL'
- Added `setup_database` for cases the database already exist. Set to false, it will skip the database setting part. | Default: 'true'
- Added `kc_install_demo` to install the kc demo data.
- Added `deactivate_firewall` to deactivate the firewall or leave how things are | Default: 'true'

###Working on | NOT DONE
- `setup_s2s` to turn on S2S. Not tested
- `setup_shibboleth` to turn on Shibboleth
