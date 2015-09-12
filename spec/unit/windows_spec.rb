require 'spec_helper'

describe 'java_se::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: 'C:/chef/cache', platform: 'windows', version: '2008R2') do |node|
        ENV['ProgramW6432'] = 'C:\Program Files'
        node.set['java_se']['arch'] = 'x64'
        node.set['java_se']['win_javalink'] = 'C:\java\jdk\bin' # test multiple directories
      end.converge(described_recipe)
    end

    it 'installs open_uri_redirections gem' do
      expect(chef_run).to install_chef_gem('open_uri_redirections')
    end

    it 'fetches java' do
      expect(chef_run).to run_ruby_block(
        'fetch http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-windows-x64.exe')
    end

    it 'validates java' do
      expect(chef_run).to run_ruby_block('validate C:/chef/cache/jdk-7u79-windows-x64.exe')
    end

    it 'installs java' do
      expect(chef_run).to run_execute('install jdk-7u79-windows-x64.exe to C:\Program Files\Java\jdk1.8.0_60')
    end

    it 'sets JAVA_HOME' do
      expect(chef_run).to create_env('JAVA_HOME')
    end

    it 'sets PATH' do
      expect(chef_run).to modify_env('PATH')
    end

    it 'creates dir' do
      expect(chef_run).to create_directory('C:\java')
    end

    it 'creates dir' do
      expect(chef_run).to create_directory('C:\java\jdk')
    end

    it 'removes simlink to bin' do
      expect(chef_run).to_not run_execute('rmdir /Q "C:\java\jdk\bin"')
    end

    it 'creates simlink to bin' do
      expect(chef_run).to_not run_execute('mklink /D "C:\java\jdk\bin" "C:\Program Files\Java\jdk1.8.0_60\bin"')
    end
  end
end
