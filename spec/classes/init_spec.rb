require 'spec_helper'
describe 'kualicoeus' do

  context 'with defaults for all parameters' do
    it { should contain_class('kualicoeus') }
  end
end
