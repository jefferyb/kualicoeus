require 'spec_helper'
describe 'kualicoeus', :type => 'class' do

#   Dir.glob('tests/*.pp').each do |file| 
#     let(:facts) {{ :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemrelease => '7.0', :kernel => 'Linux' }} 
#     context file do 
#       let(:pre_condition) { File.read(file) } 
#       it{ should compile } 
#     end 
#   end 
# end


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

  context 'On a Ubuntu 12.04 OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbmajdistrelease => '12', :lsbdistcodename => 'precise', :kernel => 'Linux'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a Ubuntu 13.04 OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbmajdistrelease => '13', :lsbdistcodename => 'raring', :kernel => 'Linux'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a Ubuntu 14.04 OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbmajdistrelease => '14', :lsbdistcodename => 'trusty', :kernel => 'Linux'
      }
    end

    it { should contain_class('kualicoeus') }

  end

  context 'On a Debian OS with defaults for all parameters' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Debian', :lsbmajdistrelease => '7', :lsbdistcodename => 'wheezy', :kernel => 'Linux'
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

  context 'Setup p6spy On a RedHat OS' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemrelease => '7.0', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :setup_p6spy => true,
      }
    end

    it { is_expected.to contain_file("spy.properties File").with_ensure('present').with_content(/p6spy_sql.log/).with('mode' => '0664') }
    it { is_expected.to contain_staging__file('p6spy-2.1.2.jar') }

  end

  context 'Setup p6spy On a Ubuntu OS' do
    let :facts do
      {
        :osfamily => 'Debian', :operatingsystem => 'Ubuntu', :lsbdistid => 'Ubuntu', :lsbmajdistrelease => '14', :lsbdistcodename => 'trusty', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :setup_p6spy => true,
      }
    end

    it { is_expected.to contain_file("spy.properties File").with_ensure('present').with_content(/p6spy_sql.log/).with('mode' => '0664') }
    it { is_expected.to contain_staging__file('p6spy-2.1.2.jar') }

  end

  context 'Setup p6spy using my own spy.properties file On a RedHat OS' do
    let :facts do
      {
        :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemrelease => '7.0', :kernel => 'Linux'
      }
    end
    let :params do
      {
        :setup_p6spy => true,
        :p6spy_my_spy_file => true,
        :p6spy_my_spy_file_source => 'puppet:///modules/kualicoeus/my_spy.properties',
      }
    end

    it { is_expected.to contain_file("My Own spy.properties File").with_ensure('present').with('mode' => '0664') }
    it { is_expected.to contain_staging__file('p6spy-2.1.2.jar') }

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
