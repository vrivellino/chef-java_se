require 'spec_helper'
require 'mixlib/shellout'

describe 'java_se::default' do
  context 'mac_os_x' do
    let(:shellout) { double(exitstatus: 1, run_command: nil, error!: nil, stdout: '') }

    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: CACHE, platform: 'mac_os_x', version: '10.14') do
        allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
      end.converge(described_recipe)
    end

    it 'fetches java' do
      expect(chef_run).to run_ruby_block(
        "fetch http://download.oracle.com/otn-pub/java/jdk/#{VERSION}+#{BUILD}" \
        "/#{HASH}/jdk-#{VERSION}_osx-x64_bin.dmg"
      )
    end

    it 'attaches volume' do
      expect(chef_run).to run_execute(
        "hdiutil attach '#{CACHE}/jdk-#{VERSION}_osx-x64_bin.dmg' -quiet"
      )
    end

    it 'install pkg' do
      expect(chef_run).to run_execute(
        "sudo installer -pkg '/Volumes/JDK #{VERSION}/JDK #{VERSION}.pkg' -target /"
      )
    end

    it 'detaches volume' do
      expect(chef_run).to run_execute("hdiutil detach '/Volumes/JDK #{VERSION}' " \
        "|| hdiutil detach '/Volumes/JDK #{VERSION}' -force")
    end

    it 'adds BundledApp capability' do
      expect(chef_run).to run_execute('/usr/bin/sudo /usr/libexec/PlistBuddy -c ' \
        '"Add :JavaVM:JVMCapabilities: string BundledApp" ' \
        "/Library/Java/JavaVirtualMachines/jdk#{VERSION}.jdk/Contents/Info.plist")
    end

    it 'adds JNI capability' do
      expect(chef_run).to run_execute('/usr/bin/sudo /usr/libexec/PlistBuddy -c ' \
        '"Add :JavaVM:JVMCapabilities: string JNI" ' \
        "/Library/Java/JavaVirtualMachines/jdk#{VERSION}.jdk/Contents/Info.plist")
    end

    it 'adds WebStart capability' do
      expect(chef_run).to run_execute('/usr/bin/sudo /usr/libexec/PlistBuddy -c ' \
        '"Add :JavaVM:JVMCapabilities: string WebStart" ' \
        "/Library/Java/JavaVirtualMachines/jdk#{VERSION}.jdk/Contents/Info.plist")
    end

    it 'adds Applets capability' do
      expect(chef_run).to run_execute('/usr/bin/sudo /usr/libexec/PlistBuddy -c ' \
        '"Add :JavaVM:JVMCapabilities: string Applets" ' \
        "/Library/Java/JavaVirtualMachines/jdk#{VERSION}.jdk/Contents/Info.plist")
    end

    it 'removes previous jdk' do
      expect(chef_run).to_not run_execute('/usr/bin/sudo /bin/rm -rf ' \
        '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK')
    end

    it 'adds current jdk' do
      expect(chef_run).to_not run_execute('/usr/bin/sudo /bin/ln -nsf ' \
        "/Library/Java/JavaVirtualMachines/jdk#{VERSION}.jdk/Contents " \
        '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK')
    end

    it 'creates java home' do
      expect(chef_run).to run_execute('/usr/bin/sudo /bin/ln -nsf ' \
        "/Library/Java/JavaVirtualMachines/jdk#{VERSION}.jdk"\
        '/Contents/Home /Library/Java/Home')
    end
  end
end
