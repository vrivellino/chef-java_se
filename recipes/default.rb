# https://github.com/caskroom/homebrew-cask/blob/master/Casks/java.rb
# https://chocolatey.org/packages/jdk8
#

arch = node['kernel']['machine'] =~ /x86_64/ ? 'x64' : 'i586'
arch = 'i586' if node['java_se']['32bit_only'] && !platform?('mac_os_x')

version = node['java_se']['version']
build = node['java_se']['build']

case node['platform_family']
when 'debian', 'rhel', 'fedora'
  jdk = "jdk-#{version}-linux-#{arch}.tar.gz"
  checksum = node['java_se']['sha256']['tar'][arch]
when 'mac_os_x'
  jdk = "jdk-#{version}-macosx-#{arch}.dmg"
  checksum = node['java_se']['sha256']['dmg']['x64']
when 'windows'
  jdk = "jdk-#{version}-windows-#{arch}.exe"
  checksum = node['java_se']['sha256']['exe'][arch]
end

if node['java_se']['url'].nil?
  download_url = "http://download.oracle.com/otn-pub/java/jdk/#{version}-b#{build}/#{jdk}"
else
  download_url = "#{node['java_se']['url']}/#{jdk}"
end

download_path = "#{Chef::Config[:file_cache_path]}/#{jdk}"

gem_package 'open_uri_redirections' do
  version '0.2.1'
end

ruby_block 'download java se' do
  block do
    unless ::File.exist?(download_path) && JavaSE.valid?(download_path, checksum)
      JavaSE.download(download_url, download_path)
      JavaSE.validate(download_path, checksum)
    end
  end
end


# case node['platform_family']
# when 'mac_os_x'
#   # dmg_package "JavaForOSX" do
#   #   source download_url
#   #   volumes_dir dmg_volumes_dir
#   #   action :install
#   #   type "pkg"
#   #   package_id "com.apple.pkg.JavaForMacOSX107"
#   #   checksum dmg_checksum
#   # end
# when 'windows'
#   bit = arch == 'x64' ? '64' : '32'
#   node.set['java']['install_flavor'] = "windows"
#   node.set['java']['windows']['url'] = download_url
#   node.set['java']['windows']['checksum'] = checksum
#   node.set['java']['windows']['package_name'] = "Java(TM) SE Development Kit 7 (#{bit}-bit)"
#
# else
#   node.set['java']['install_flavor'] = "oracle"
#   node.set['java']['arch'] = arch
#   node.set['java']['jdk']['8'][arch]['url'] = download_url
#   node.set['java']['jdk']['8'][arch]['checksum'] = checksum
#   node.set['java']['jdk']['8']['bin_cmds'] = node['java_se']['bin_cmds'] if node['java_se']['bin_cmds']
#
#   if platform?('debian')
#     node.set['java']['java_home'] = "/usr/lib/jvm/java-8-oracle-#{arch == 'x64' ? 'amd64' : 'i386'}"
#   end
# end
#
# recipe_eval do
#   run_context.include_recipe 'java::default'
# end
