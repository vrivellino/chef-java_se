arch = node['java_se']['arch']

case node['platform_family']
when 'debian', 'rhel', 'fedora'
  checksum = node['java_se']['sha256']['tar'][arch]
when 'mac_os_x'
  checksum = node['java_se']['sha256']['dmg']['x64']
when 'windows'
  checksum = node['java_se']['sha256']['exe'][arch]
end

file = node['java_se']['file']
if file.nil? || file.empty?
  jdk_version = node['java_se']['jdk_version']

  case node['platform_family']
  when 'debian', 'rhel', 'fedora'
    jdk = "jdk-#{jdk_version}-linux-#{arch}.tar.gz"
  when 'mac_os_x'
    jdk = "jdk-#{jdk_version}-macosx-#{arch}.dmg"
  when 'windows'
    jdk = "jdk-#{jdk_version}-windows-#{arch}.exe"
  end

  url = node['java_se']['url']
  if url.nil? || url.empty?
    download_url = "http://download.oracle.com/otn-pub/java/jdk/#{jdk_version}-b#{node['java_se']['build']}/#{jdk}"
  else
    if %w(.dmg .exe .tar.gz).include?(url)
      download_url = url
      jdk = ::File.basename(url)
    else
      download_url = "#{url}/#{jdk}"
    end
  end

  file = File.join(Chef::Config[:file_cache_path], jdk)

  chef_gem 'open_uri_redirections' do # ~FC009
    version '0.2.1'
    compile_time false
  end

  ruby_block "fetch #{download_url}" do
    block do
      JavaSE.fetch(download_url, file)
    end
    not_if { ::File.exist?(file) && JavaSE.valid?(file, checksum) }
  end

  node.set['java_se']['file'] = file
end

ruby_block "validate #{file}" do
  block do
    JavaSE.validate(file, checksum)
  end
end
