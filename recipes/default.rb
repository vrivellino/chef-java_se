# https://github.com/caskroom/homebrew-cask/blob/master/Casks/java.rb
# https://chocolatey.org/packages/jdk8
#

arch = kernel['machine'] =~ /x86_64/ ? 'x64' : 'i586'
arch = 'i586' if node['java_se']['32bit_only'] && node['platform'] != 'mac_os_x'

   # Oracle SHA256 checksums https://www.oracle.com/webfolder/s/digest/8u51checksum.html
case node['platform_family']
when 'debian'
  package 'tar'
  jdk = "jdk-#{version}-linux-#{arch}.tar.gz"
  checksum = ['java_se']['sha256']['tar'][arch]
  java_home = "/usr/lib/jvm/java-#{node['java']['jdk_version']}-oracle"
  java_home = "#{java_home}-#{node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'}"

when 'rhel', 'fedora'
  jdk = "jdk-#{version}-linux-#{arch}.rpm"
  checksum = ['java_se']['sha256']['rpm'][arch]
  java_home = "/usr/lib/jvm/java"
when 'mac_os_x'
  jdk = "jdk-#{version}-macosx-#{arch}.dmg"
  checksum = ['java_se']['sha256']['dmg']['x64']
when 'windows'
  jdk = "jdk-#{version}-windows-#{arch}.exe"
  checksum = ['java_se']['sha256']['exe'][arch]
else
  # if platform_family?('debian') &&
end

if node['java_se']['url'].nil?
  url = "http://download.oracle.com/otn-pub/java/jdk/8u51-b16/#{jdk}"
else
  url =  "#{node['java_se']['url']}/#{jdk}"
end

bin_cmds = node['java']['jdk']['8']['bin_cmds']


#
#  set java home
#
ruby_block  "set-env-java-home" do
  block do
    ENV["JAVA_HOME"] = node['java']['java_home']
  end
  not_if { ENV["JAVA_HOME"] == node['java']['java_home'] }
end

directory "/etc/profile.d" do
  mode 00755
end

file "/etc/profile.d/jdk.sh" do
  content "export JAVA_HOME=#{node['java']['java_home']}"
  mode 00755
end

if node['java']['set_etc_environment']
  ruby_block "Set JAVA_HOME in /etc/environment" do
    block do
      file = Chef::Util::FileEdit.new("/etc/environment")
      file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{node['java']['java_home']}")
      file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{node['java']['java_home']}")
      file.write_file
    end
  end
end


java_ark "jdk" do
  url tarball_url
  default node['java']['set_default']
  checksum tarball_checksum
  app_home java_home
  bin_cmds bin_cmds
  alternatives_priority node['java']['alternatives_priority']
  retries node['java']['ark_retries']
  retry_delay node['java']['ark_retry_delay']
  connect_timeout node['java']['ark_timeout']
  use_alt_suffix node['java']['use_alt_suffix']
  reset_alternatives node['java']['reset_alternatives']
  action :install
end

if node['java']['set_default'] && platform_family?('debian')
  include_recipe 'java::default_java_symlink'
end
