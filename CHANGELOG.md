##2014-11-30 - Supported Release 0.1.3

This release adds e-mail notifications, KC & KEW, option to use Oracle Database 
for testing (using docker) and added more settings to the kc-config.xml file. 
Also updated dependencies.

####Features
Added `setup_tomcat` to choose to choose if you want to setup tomcat or not using this module | Default: 'true'
Added `database_type` to choose between MySQL and Oracle | Default: 'MysSQL'
Added `setup_database` for cases the database already exist. Set to false, it will skip the database setting part. | Default: 'true'
Added `kc_install_demo` to install the kc demo data.
Added `deactivate_firewall` to deactivate the firewall or leave how things are | Default: 'true'

#####Working on | NOT DONE
`activate_s2s` to turn on S2S. Not tested
`activate_shibboleth` to turn on Shibboleth
