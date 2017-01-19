def java_arch
  arch = node['kernel']['machine'] =~ /x86_64/ ? 'x64' : 'i586'
  arch = 'i586' if node['java_se']['force_i586'] && !platform?('mac_os_x')
  arch
end

def java_version
  "1.#{node['java_se']['release']}.0_#{node['java_se']['update']}"
end

def jdk_version
  "#{node['java_se']['release']}u#{node['java_se']['update']}"
end

def java_version_on_macosx?
  cmd = Mixlib::ShellOut.new("pkgutil --pkgs='com.oracle.jdk#{jdk_version}'")
  cmd.run_command
  cmd.exitstatus.zero?
end

def win_install_dir
  if ENV['ProgramW6432'].nil?
    ENV['ProgramFiles']
  else
    java_arch == 'x64' ? ENV['ProgramW6432'] : ENV['ProgramFiles(x86)']
  end
end

# rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
def fetch_java_installer
  case node['platform_family']
  when 'mac_os_x'
    checksum = node['java_se']['sha256']['dmg']['x64']
    jdk = "jdk-#{jdk_version}-macosx-#{java_arch}.dmg"
  when 'windows'
    checksum = node['java_se']['sha256']['exe'][java_arch]
    jdk = "jdk-#{jdk_version}-windows-#{java_arch}.exe"
  else
    checksum = node['java_se']['sha256']['tar'][java_arch]
    jdk = "jdk-#{jdk_version}-linux-#{java_arch}.tar.gz"
  end

  uri = node['java_se']['uri']
  if uri.nil? || uri.empty?
    download_url = "http://download.oracle.com/otn-pub/java/jdk/#{jdk_version}-b#{node['java_se']['build']}/" \
        "#{node['java_se']['hash']}/#{jdk}"
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
# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
