require 'spec_helper'

describe 'java_se::_download_java' do
  context 'default' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache', platform: 'centos', version: '7.0') do |node|
        node.set['java_se']['arch'] = 'x64'
        node.set['java_se']['jdk_version'] = "#{VERSION_MAJOR}u#{VERSION_UPDATE}"
      end.converge(described_recipe)
    end

    it 'installs open_uri_redirections gem' do
      expect(chef_run).to install_chef_gem('open_uri_redirections')
    end

    it 'fetches java' do
      expect(chef_run).to run_ruby_block(
        "fetch http://download.oracle.com/otn-pub/java/jdk/#{VERSION_MAJOR}u#{VERSION_UPDATE}-b#{BUILD}"\
        "/jdk-#{VERSION_MAJOR}u#{VERSION_UPDATE}-linux-x64.tar.gz")
    end

    it 'does not validate java' do
      expect(chef_run).to_not run_ruby_block(
        "validate /var/chef/cache/jdk-#{VERSION_MAJOR}u#{VERSION_UPDATE}-linux-x64.tar.gz")
    end
  end

  context 'url_dir' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache', platform: 'centos', version: '7.0') do |node|
        node.set['java_se']['arch'] = 'x64'
        node.set['java_se']['jdk_version'] = "#{VERSION_MAJOR}u#{VERSION_UPDATE}"
        node.set['java_se']['uri'] = 'https://example.com/path/to/jdks/'
      end.converge(described_recipe)
    end

    it 'installs open_uri_redirections gem' do
      expect(chef_run).to install_chef_gem('open_uri_redirections')
    end

    it 'fetches java' do
      expect(chef_run).to run_ruby_block(
        "fetch https://example.com/path/to/jdks//jdk-#{VERSION_MAJOR}u#{VERSION_UPDATE}-linux-x64.tar.gz")
    end

    it 'does not validate java' do
      expect(chef_run).to_not run_ruby_block(
        "validate /var/chef/cache/jdk-#{VERSION_MAJOR}u#{VERSION_UPDATE}-linux-x64.tar.gz")
    end
  end

  context 'url_file' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache', platform: 'centos', version: '7.0') do |node|
        node.set['java_se']['arch'] = 'x64'
        node.set['java_se']['jdk_version'] = "#{VERSION_MAJOR}u#{VERSION_UPDATE}"
        node.set['java_se']['uri'] = 'https://example.com/path/to/jdks/myjdk.tar.gz'
      end.converge(described_recipe)
    end

    it 'fetches java' do
      expect(chef_run).to run_ruby_block(
        'fetch https://example.com/path/to/jdks/myjdk.tar.gz')
    end

    it 'does not validate java' do
      expect(chef_run).to_not run_ruby_block('validate /var/chef/cache/myjdk.tar.gz')
    end
  end

  context 'file_dir' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache', platform: 'centos', version: '7.0') do |node|
        node.set['java_se']['arch'] = 'x64'
        node.set['java_se']['jdk_version'] = "#{VERSION_MAJOR}u#{VERSION_UPDATE}"
        node.set['java_se']['uri'] = 'file:///var/chef/cache/jdks/'
      end.converge(described_recipe)
    end

    it 'does not fetch java' do
      expect(chef_run).to_not run_ruby_block(
        "fetch /var/chef/cache/jdks//jdk-#{VERSION_MAJOR}u#{VERSION_UPDATE}-linux-x64.tar.gz")
    end

    it 'validates java' do
      expect(chef_run).to run_ruby_block(
        "validate /var/chef/cache/jdks//jdk-#{VERSION_MAJOR}u#{VERSION_UPDATE}-linux-x64.tar.gz")
    end
  end

  context 'file_path' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache', platform: 'centos', version: '7.0') do |node|
        node.set['java_se']['arch'] = 'x64'
        node.set['java_se']['jdk_version'] = "#{VERSION_MAJOR}u#{VERSION_UPDATE}"
        node.set['java_se']['uri'] = 'file:///var/chef/cache/myjdk.tar.gz'
      end.converge(described_recipe)
    end

    it 'does not fetche java' do
      expect(chef_run).to_not run_ruby_block(
        'fetch /var/chef/cache/myjdk.tar.gz')
    end

    it 'validates java' do
      expect(chef_run).to run_ruby_block('validate /var/chef/cache/myjdk.tar.gz')
    end
  end

  context 'windows_file' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
        node.set['java_se']['arch'] = 'x64'
        node.set['java_se']['jdk_version'] = "#{VERSION_MAJOR}u#{VERSION_UPDATE}"
        node.set['java_se']['uri'] = 'file:///c|/chef/cache/myjdk.exe'
      end.converge(described_recipe)
    end

    it 'validates java' do
      expect(chef_run).to run_ruby_block('validate c:\chef\cache\myjdk.exe')
    end
  end
end
