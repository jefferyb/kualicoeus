require 'spec_helper'

describe 'kualicoeus::config::sqlplus', :type => :class  do

  context 'On a RedHat OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :oracle_service_name => 'XE',
        :oracle_hostname => 'localhost',
        :oracle_port => '49161',
        :tnsnames_location => '/opt/oracle'
      }
    end

    it { 
      should contain_exec('Create Oracle Folder') 
      should contain_exec('Download sqlplus') 
      should contain_exec('Download oracle-instantclient12.1-basic') 
      should contain_exec('Download oracle-instantclient12.1-devel') 
      should contain_file('/usr/bin/sqlplus')
      should contain_file('/etc/ld.so.conf.d/oracle.conf')
      should contain_file('/opt/oracle/tnsnames.ora').with_content(/SERVICE_NAME = XE/)
      should contain_exec('Install sqlplus files') 
      should contain_exec('Run the dynamic linker') 
      should contain_exec('TNSNAMES.ORA location') 
    }

  end

  context 'On a RedHat OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemrelease => '7.0', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :oracle_service_name => 'XE',
        :oracle_hostname => 'localhost',
        :oracle_port => '49161',
        :tnsnames_location => '/opt/oracle'
      }
    end

    it { 
      should contain_exec('Create Oracle Folder') 
      should contain_exec('Download sqlplus') 
      should contain_exec('Download oracle-instantclient12.1-basic') 
      should contain_exec('Download oracle-instantclient12.1-devel') 
      should contain_file('/usr/bin/sqlplus')
      should contain_file('/etc/ld.so.conf.d/oracle.conf')
      should contain_file('/opt/oracle/tnsnames.ora').with_content(/SERVICE_NAME = XE/)
      should contain_exec('Install sqlplus files') 
      should contain_exec('Run the dynamic linker') 
      should contain_exec('TNSNAMES.ORA location') 
    }

  end

  context 'On a Ubuntu OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbdistcodename => 'trusty', :kernel => 'Linux', :lsbdistid => 'Ubuntu'
      }
    end
    let :params do
      {
        :oracle_service_name => 'XE',
        :oracle_hostname => 'localhost',
        :oracle_port => '49161',
        :tnsnames_location => '/opt/oracle'
      }
    end

    it { 
      should contain_exec('Create Oracle Folder') 
      should contain_exec('Download sqlplus') 
      should contain_exec('Download oracle-instantclient12.1-basic') 
      should contain_exec('Download oracle-instantclient12.1-devel') 
      should contain_file('/usr/bin/sqlplus')
      should contain_file('/etc/ld.so.conf.d/oracle.conf')
      should contain_file('/opt/oracle/tnsnames.ora').with_content(/SERVICE_NAME = XE/)
      should contain_exec('Install sqlplus files') 
      should contain_exec('Run the dynamic linker') 
      should contain_exec('TNSNAMES.ORA location') 
    }

  end

end
