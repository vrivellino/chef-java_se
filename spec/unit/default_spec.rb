require 'spec_helper'

describe 'java_se::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: 'C:/chef/cache', platform: 'windows', version: '2008R2').converge(described_recipe)
    end

    it 'installs open_uri_redirections gem' do
      expect(chef_run).to install_gem_package('open_uri_redirections')
    end

    it 'fetches java' do
      expect(chef_run).to run_ruby_block(
        'fetch http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-windows-x64.exe')
    end

    it 'installs java' do
      expect(chef_run).to run_ruby_block(
        'install jdk-8u51-windows-x64.exe to \Java\jdk1.8.0_51')
    end

    it 'sets JAVA_HOME' do
      expect(chef_run).to create_env('JAVA_HOME')
    end
    it 'sets PATH' do
      expect(chef_run).to modify_env('PATH')
    end
  end

  context 'linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: '/var/chef/cache', platform: 'centos', version: '7.0').converge(described_recipe)
    end
  end

  context 'mac_os_x' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: '/var/chef/cache', platform: 'mac_os_x', version: '10.10').converge(described_recipe)
    end
  end
end
