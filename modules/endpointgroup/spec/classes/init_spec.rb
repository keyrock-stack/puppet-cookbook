require 'spec_helper'
describe 'endpointgroup' do
  context 'with default values for all parameters' do
    it { should contain_class('endpointgroup') }
  end
end
