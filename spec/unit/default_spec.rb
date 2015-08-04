require 'spec_helper'

describe 'java_se::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge(described_recipe)
  end


end
