require 'spec_helper'
describe 'kualicoeus', :type => 'class' do

  ####### Using defaults for all params
  context 'On a RedHat OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'RedHat', :kernel => 'Linux'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a CentOS OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'CentOS', :kernel => 'Linux'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a Ubuntu OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbdistcodename => 'trusty', :kernel => 'Linux'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a Debian OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Debian', :lsbdistcodename => 'trusty', :kernel => 'Linux'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On an unknown OS with defaults for all parameters' do
    let :facts do
      {
        :operatingsystem => 'Darwin'
      }
    end

    it {
      expect { should raise_error(Puppet::Error) }
    }
  end

  ####### With database_type params set
  context 'On a RedHat OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :database_type => 'oracle'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a RedHat OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemrelease => '7.0', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :database_type => 'oracle'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a Ubuntu OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbdistcodename => 'trusty', :kernel => 'Linux', :lsbdistid => 'Ubuntu'
      }
    end
    let :params do
      {
        :database_type => 'oracle'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  ####### With setup_tomcat params set
  context 'On a RedHat OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemrelease => '6.5', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :setup_tomcat => false
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a RedHat OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemrelease => '7.0', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :setup_tomcat => false
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a Ubuntu OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbdistcodename => 'trusty', :kernel => 'Linux', :lsbdistid => 'Ubuntu'
      }
    end
    let :params do
      {
        :setup_tomcat => false
      }
    end

    it { should contain_class('kualicoeus') }

  end

  ####### Should fail

  context 'On a CentOS OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'CentOS', :operatingsystemrelease => '7.0', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :database_type => 'SQL'
      }
    end

    it {
      expect { should raise_error(Puppet::Error, /Only 'MYSQL' and 'ORACLE' are supported/) }
    }

  end


end
