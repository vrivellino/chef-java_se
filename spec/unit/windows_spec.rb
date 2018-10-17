require 'spec_helper'

describe 'java_se::default' do
  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2008R2') do |node|
        allow(::File).to receive(:exist?).and_call_original
        allow(::File).to receive(:exist?).with("#{ENV['SYSTEMDRIVE']}\\java\\jdk").and_return(false)
        ENV['SYSTEMDRIVE'] = 'C:'
        ENV['ProgramW6432'] = 'C:\Program Files'
        node.override['java_se']['win_javalink'] = "#{ENV['SYSTEMDRIVE']}\\java\\jdk\\bin" # test multiple directories
      end.converge(described_recipe)
    end

    it 'fetches java' do
      expect(chef_run).to run_ruby_block(
        "fetch http://download.oracle.com/otn-pub/java/jdk/#{VERSION}+#{BUILD}/#{HASH}" \
            "/jdk-#{VERSION}_windows-x64_bin.exe"
      )
    end

    it 'installs java' do
      expect(chef_run).to run_execute(
        "install jdk-#{VERSION}_windows-x64_bin.exe to C:\\Program Files\\Java\\jdk-#{VERSION}"
      )
    end

    it 'sets JAVA_HOME' do
      expect(chef_run).to create_env('JAVA_HOME')
    end

    it 'sets PATH' do
      expect(chef_run).to modify_env('Add java_se JDK to path').with(key_name: 'PATH')
    end

    it 'creates dir' do
      expect(chef_run).to create_directory('C:\java\jdk').with(recursive: true)
    end

    it 'creates link to JDK bin' do
      expect(chef_run).to create_link('C:\java\jdk\bin').with(
        to: "C:\\Program Files\\Java\\jdk-#{VERSION}\\bin"
      )
    end
  end
end
