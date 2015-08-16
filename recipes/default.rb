# https://github.com/caskroom/homebrew-cask/blob/master/Casks/java.rb
# https://chocolatey.org/packages/jdk8

gem_package 'open_uri_redirections' do
  version '0.2.1'
end

arch = node['kernel']['machine'] =~ /x86_64/ ? 'x64' : 'i586'
arch = 'i586' if node['java_se']['force_i586'] && !platform?('mac_os_x')

version = node['java_se']['version'].sub(/^\d+\.(\d+).*?_(.*)$/, '\1u\2')
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

file_cache_path = File.join(Chef::Config[:file_cache_path], jdk)

unless ::File.exist?(file_cache_path) && JavaSE.valid?(file_cache_path, checksum)
  ruby_block "download from #{download_url}" do
    block do
      JavaSE.download(download_url, file_cache_path)
      JavaSE.validate(file_cache_path, checksum)
    end
  end
end

case node['platform_family']
when 'mac_os_x'
  # dmg_package "JavaForOSX" do
  #   source download_url
  #   volumes_dir dmg_volumes_dir
  #   action :install
  #   type "pkg"
  #   package_id "com.apple.pkg.JavaForMacOSX107"
  #   checksum dmg_checksum
  # end
when 'windows'
  program_files = arch == 'x64' ? ENV['ProgramW6432'] : ENV['ProgramFiles(x86)']
  java_home = "#{program_files}\\Java\\jdk#{node['java_se']['version']}"

  env 'JAVA_HOME' do
    value java_home
  end

  unless ::File.exist?(java_home)
    ruby_block "install #{::File.basename(file_cache_path)}" do
      block do
        exec = Mixlib::ShellOut.new("start \"\" /wait \"#{file_cache_path}\""\
          " /s ADDLOCAL=\"ToolsFeature,SourceFeature,PublicjreFeature\" & exit %%%%ERRORLEVEL%%%%")
        exec.run_command
        exec.error!
      end
    end
  end
end

# recipe_eval do
#   run_context.include_recipe 'java::default'
# end
