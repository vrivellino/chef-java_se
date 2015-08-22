# TODO: REMOVE IN JAVA 9 RELEASE
file = node['java_se']['file']
unless file.nil? || file.empty?
  node.set['java_se']['uri'] = "file://#{platform?('windows') ? '/' : ''}#{file.gsub('\\', '/').gsub('//', '/')}"
  Chef::Log.warn("Attribute node['java_se']['file'] is deprecated in favor of node['java_se']['uri'] "\
    "and will be removed in Java 9 release!")
end

# TODO: REMOVE IN JAVA 9 RELEASE
url = node['java_se']['url']
unless url.nil? || url.empty?
  node.set['java_se']['uri'] = url
  Chef::Log.warn("Attribute node['java_se']['url'] is deprecated in favor of node['java_se']['uri'] "\
    "and will be removed in Java 9 release!")
end

arch = node['java_se']['arch']
jdk_version = node['java_se']['jdk_version']

case node['platform_family']
when 'debian', 'rhel', 'fedora'
  checksum = node['java_se']['sha256']['tar'][arch]
  jdk = "jdk-#{jdk_version}-linux-#{arch}.tar.gz"
when 'mac_os_x'
  checksum = node['java_se']['sha256']['dmg']['x64']
  jdk = "jdk-#{jdk_version}-macosx-#{arch}.dmg"
when 'windows'
  checksum = node['java_se']['sha256']['exe'][arch]
  jdk = "jdk-#{jdk_version}-windows-#{arch}.exe"
end

uri = node['java_se']['uri']
if uri.nil? || uri.empty?
  download_url = "http://download.oracle.com/otn-pub/java/jdk/#{jdk_version}-b#{node['java_se']['build']}/#{jdk}"
elsif uri.start_with?('file://')
  file_cache_path = platform?('windows') ? uri.gsub('file:///', '').gsub('/', '\\').gsub('|', ':') : uri.gsub('file://', '')
else
  if %w(.dmg .exe .tar.gz).include?(url)
    download_url = url
    jdk = ::File.basename(url)
  else
    download_url = "#{url}/#{jdk}"
  end
end

unless file_cache_path
  file_cache_path = File.join(Chef::Config[:file_cache_path], jdk)

  chef_gem 'open_uri_redirections' do # ~FC009
    version '0.2.1'
  end

  ruby_block "fetch #{download_url}" do
    block do
      JavaSE.fetch(download_url, file_cache_path)
    end
    not_if { ::File.exist?(file_cache_path) && JavaSE.valid?(file_cache_path, checksum) }
  end
end

ruby_block "validate #{file_cache_path}" do
  block do
    JavaSE.validate(file_cache_path, checksum)
  end
end

node.set['java_se']['file_cache_path'] = file_cache_path
