arch = node['java_se']['arch']
jdk_version = node['java_se']['jdk_version']

case node['platform_family']
when 'mac_os_x'
  checksum = node['java_se']['sha256']['dmg']['x64']
  jdk = "jdk-#{jdk_version}-macosx-#{arch}.dmg"
when 'windows'
  checksum = node['java_se']['sha256']['exe'][arch]
  jdk = "jdk-#{jdk_version}-windows-#{arch}.exe"
else
  checksum = node['java_se']['sha256']['tar'][arch]
  jdk = "jdk-#{jdk_version}-linux-#{arch}.tar.gz"
end

uri = node['java_se']['uri']
if uri.nil? || uri.empty?
  download_url = "http://download.oracle.com/otn-pub/java/jdk/#{jdk_version}-b#{node['java_se']['build']}/#{jdk}"
elsif uri.start_with?('file://')
  file_cache_path = platform?('windows') ? uri.gsub('file:///', '').tr('/', '\\').tr('|', ':') : uri.gsub('file://', '')
  file_cache_path = "#{file_cache_path}/#{jdk}" unless uri =~ /.*(\.dmg|\.exe|\.tar\.gz)$/
elsif uri =~ /.*(\.dmg|\.exe|\.tar\.gz)$/
  download_url = uri
  jdk = ::File.basename(uri)
else
  download_url = "#{uri}/#{jdk}"
end

if file_cache_path
  ruby_block "validate #{file_cache_path}" do
    block do
      JavaSE::Downloader.validate(file_cache_path, checksum)
    end
  end
else
  file_cache_path = ::File.join(Chef::Config[:file_cache_path], jdk)

  chef_gem 'allow for https to http redirections' do
    package_name 'open_uri_redirections'
    version '0.2.1'
    compile_time false if Chef::Resource::ChefGem.method_defined?(:compile_time)
  end

  Chef::Log.info("download #{download_url}")
  ruby_block "fetch #{download_url}" do
    block do
      JavaSE::Downloader.fetch(download_url, file_cache_path, checksum)
    end
    not_if { ::File.exist?(file_cache_path) && JavaSE::Downloader.valid?(file_cache_path, checksum) }
  end
end

node.set['java_se']['file_cache_path'] = file_cache_path
