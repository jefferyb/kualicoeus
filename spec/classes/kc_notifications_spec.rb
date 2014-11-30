require 'spec_helper'

describe 'kualicoeus::config::kc_notifications', :type => :class  do

  context 'On a CentOS 6.5 with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => '6.5', :kernel => 'Linux'
      }
    end

    it {
      expect { should raise_error(Puppet::Error) }
    }

  end

  context 'On a CentOS 6.5 with parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => '6.5', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :kc_email_notifications => 'Y',
        :kc_email_notification_test_enabled => 'N',
        :kc_email_notification_from_address => 'kc.notifications@example.edu',
        :kc_email_notification_test_address => 'notification@example.edu',
        :database_type => 'MYSQL'
      }
    end

    it { 
      should contain_file('Getting kc email notifications sql script').with_content(/Y/)
      should contain_exec('Set KC related email parameters') 
    }

  end

  context 'On a CentOS 7.0 with parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => '7.0', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :kc_email_notifications => 'N',
        :kc_email_notification_test_enabled => 'N',
        :kc_email_notification_from_address => 'kc.notifications@example.edu',
        :kc_email_notification_test_address => 'notification@example.edu',
        :database_type => 'ORACLE'
      }
    end

    it { 
      should contain_file('Getting kc email notifications sql script').with_content(/kc.notifications@example.edu/)
      should contain_exec('Set KC related email parameters') 
    }

  end

  context 'On a Ubuntu 14.04 with parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbdistcodename => 'trusty', :kernel => 'Linux', :lsbdistid => 'Ubuntu'
      }
    end
    let :params do
      {
        :kc_email_notifications => 'Y',
        :kc_email_notification_test_enabled => 'N',
        :kc_email_notification_from_address => 'kc.notifications@example.edu',
        :kc_email_notification_test_address => 'notification@example.edu',
        :database_type => 'MYSQL'
      }
    end

    it { 
      should contain_file('Getting kc email notifications sql script').with_content(/notification@example.edu/)
      should contain_exec('Set KC related email parameters') 
    }

  end

  context 'On an unknown Database with parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => '7.0', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :kc_email_notifications => 'Y',
        :kc_email_notification_test_enabled => 'N',
        :kc_email_notification_from_address => 'kc.notifications@example.edu',
        :kc_email_notification_test_address => 'notification@example.edu',
        :database_type => 'SQL'
      }
    end

    it {
      expect { should raise_error(Puppet::Error, /Only 'MYSQL' and 'ORACLE' are supported/) }
    }
  end
  
end
