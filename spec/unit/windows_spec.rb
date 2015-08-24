require 'spec_helper'

describe 'java_se::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        file_cache_path: 'C:/chef/cache', platform: 'windows', version: '2008R2').converge(described_recipe)
    end

    it 'installs open_uri_redirections gem' do
      expect(chef_run).to install_chef_gem('open_uri_redirections')
    end

    it 'fetches java' do
      expect(chef_run).to run_ruby_block(
        'fetch http://download.oracle.com/otn-pub/java/jdk/8u60-b16/jdk-8u60-windows-x64.exe')
    end

    it 'validates java' do
      expect(chef_run).to run_ruby_block('validate C:/chef/cache/jdk-8u60-windows-x64.exe')
    end

    it 'installs java' do
      expect(chef_run).to run_ruby_block(
        'install jdk-8u60-windows-x64.exe to \Java\jdk1.8.0_60')
    end

    it 'sets JAVA_HOME' do
      expect(chef_run).to create_env('JAVA_HOME')
    end

    it 'sets PATH' do
      expect(chef_run).to modify_env('PATH')
    end
  end
end
