require 'spec_helper'

describe 'java_se::default' do
  context 'skip install' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'debian', version: '8.0') do |node|
        node.override['java_se']['skip'] = true
      end.converge(described_recipe)
    end

    it 'does nothing' do
      expect(chef_run).to_not include_recipe('java_se::_download_java')
      expect(chef_run).to_not include_recipe('java_se::_linux_install')
      expect(chef_run).to_not include_recipe('java_se::_macosx_install')
      expect(chef_run).to_not include_recipe('java_se::_windows_install')
    end
  end
end
