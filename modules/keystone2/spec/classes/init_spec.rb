require 'spec_helper'
describe 'keystone2' do
  context 'with default values for all parameters' do
    it { should contain_class('keystone2') }
  end
end
