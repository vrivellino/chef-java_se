def java_version
  (node['java_se']['release']).to_s
end

def java_version_on_macosx?
  cmd = Mixlib::ShellOut.new("pkgutil --pkgs='com.oracle.jdk-#{java_version}'")
  cmd.run_command
  cmd.exitstatus == 0
end

def win_install_dir
  ENV['ProgramW6432']
end

def fetch_java_installer
  case node['platform_family']
  when 'mac_os_x'
    checksum = node['java_se']['sha256']['dmg']
    jdk = "jdk-#{java_version}_osx-x64_bin.dmg"
  when 'windows'
    checksum = node['java_se']['sha256']['exe']
    jdk = "jdk-#{java_version}_windows-x64_bin.exe"
  else
    checksum = node['java_se']['sha256']['tar']
    jdk = "jdk-#{java_version}_linux-x64_bin.tar.gz"
  end

  uri = node['java_se']['uri']
  if uri.nil? || uri.empty?
    download_url = "http://download.oracle.com/otn-pub/java/jdk/#{java_version}+#{node['java_se']['build']}" \
        "/#{node['java_se']['hash']}/#{jdk}"
  elsif uri.start_with?('file://')
    file_cache_path =
      platform?('windows') ? uri.gsub('file:///', '').tr('/', '\\').tr('|', ':') : uri.gsub('file://', '')
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

    ruby_block "fetch #{download_url}" do
      block do
        JavaSE::Downloader.fetch(download_url, file_cache_path, checksum)
      end
      not_if { ::File.exist?(file_cache_path) && JavaSE::Downloader.valid?(file_cache_path, checksum) }
    end
  end

  file_cache_path
end
