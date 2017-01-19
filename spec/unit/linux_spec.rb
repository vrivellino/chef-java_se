require 'spec_helper'

describe 'java_se::default' do
  context 'linux' do
    context 'set_java_home' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'debian', version: '8.0') do |node|
          node.override['java_se']['java_home'] = '/opt/java'
        end.converge(described_recipe)
      end

      it 'it should set the java home environment variable' do
        expect(chef_run).to run_ruby_block('set-env-java-home')
        expect(chef_run).to_not run_ruby_block('Set JAVA_HOME in /etc/environment')
      end

      it 'should create the profile.d directory' do
        expect(chef_run).to create_directory('/etc/profile.d')
      end

      it 'should create jdk.sh with the java home environment variable' do
        expect(chef_run).to render_file('/etc/profile.d/jdk.sh').with_content('export JAVA_HOME=/opt/java')
      end

      it 'symlinks /opt/default-java' do
        link = chef_run.link('/opt/default-java')
        expect(link).to_not link_to('/opt/java')
      end
    end

    context 'set_java_home_environment' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'debian', version: '8.0') do |node|
          node.override['java_se']['java_home'] = '/opt/java'
          node.override['java_se']['set_etc_environment'] = true
        end.converge(described_recipe)
      end

      it 'installs glibc package' do
        expect(chef_run).to_not install_package('glibc')
      end

      it 'installs tar package' do
        expect(chef_run).to install_package('tar')
      end

      it 'it should set the java home environment variable' do
        expect(chef_run).to run_ruby_block('set-env-java-home')
      end

      it 'should create the profile.d directory' do
        expect(chef_run).to create_directory('/etc/profile.d')
      end

      it 'should create /etc/environment with the java home  variable' do
        expect(chef_run).to run_ruby_block('set JAVA_HOME in /etc/environment')
      end

      it 'add java' do
        expect(chef_run).to run_ruby_block("adding java to /opt/jdk1.#{VERSION_MAJOR}.0_#{VERSION_UPDATE}")
      end

      it 'symlink java' do
        expect(chef_run).to create_link('/opt/java').with(to: "/opt/jdk1.#{VERSION_MAJOR}.0_#{VERSION_UPDATE}")
      end

      it 'validates java' do
        expect(chef_run).to create_template('adding /opt/.java.jinfo for debian')
      end

      it 'symlinks /usr/lib/jvm/default-java' do
        link = chef_run.link('/usr/lib/jvm/default-java')
        expect(link).to_not link_to('/usr/lib/jvm/java')
      end
    end

    context 'centos' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0') do
        end.converge(described_recipe)
      end

      it 'fetches java' do
        expect(chef_run).to run_ruby_block(
          "fetch http://download.oracle.com/otn-pub/java/jdk/#{VERSION_MAJOR}u#{VERSION_UPDATE}-b#{BUILD}"\
          "/#{HASH}/jdk-#{VERSION_MAJOR}u#{VERSION_UPDATE}-linux-x64.tar.gz"
        )
      end

      it 'installs glibc package' do
        expect(chef_run).to_not install_yum_package('glibc')
      end

      it 'installs tar package' do
        expect(chef_run).to install_package('tar')
      end

      it 'add java' do
        expect(chef_run).to run_ruby_block("adding java to /usr/lib/jvm/jdk1.#{VERSION_MAJOR}.0_#{VERSION_UPDATE}")
      end

      it 'symlink java' do
        expect(chef_run).to create_link('/usr/lib/jvm/java').with(
          to: "/usr/lib/jvm/jdk1.#{VERSION_MAJOR}.0_#{VERSION_UPDATE}"
        )
      end

      it 'validates java' do
        expect(chef_run).to_not create_template('adding /usr/lib/jvm/.java.jinfo for debian')
      end

      it 'update-alternatives' do
        expect(chef_run).to run_ruby_block('update-alternatives')
      end

      it 'symlinks /usr/lib/jvm/default-java' do
        link = chef_run.link('/usr/lib/jvm/default-java')
        expect(link).to_not link_to('/usr/lib/jvm/java')
      end
    end

    context 'default_java_symlink' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: 'debian', version: '8.0').converge(described_recipe)
      end

      it 'symlinks /usr/lib/jvm/default-java' do
        link = chef_run.link('/usr/lib/jvm/default-java')
        expect(link).to link_to('/usr/lib/jvm/java')
      end
    end
  end
end
