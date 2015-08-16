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

url = node['java_se']['url']
if url.nil? || url.empty?
  download_url = "http://download.oracle.com/otn-pub/java/jdk/#{version}-b#{build}/#{jdk}"
else
  if %w(.dmg .exe .tar.gz).include?(url)
    download_url = url
    jdk = ::File.basename(url)
  else
    download_url = "#{url}/#{jdk}"
  end
end

file_cache_path = File.join(Chef::Config[:file_cache_path], jdk)

unless ::File.exist?(file_cache_path) && JavaSE.valid?(file_cache_path, checksum)
  ruby_block "fetch #{download_url}" do
    block do
      JavaSE.fetch(download_url, file_cache_path)
      JavaSE.validate(file_cache_path, checksum)
    end
  end
end

case node['platform_family']
when 'mac_os_x'
  # inspiration from https://github.com/caskroom/homebrew-cask/blob/master/Casks/java.rb
  # dmg_package "JavaForOSX" do
  #   source download_url
  #   volumes_dir dmg_volumes_dir
  #   action :install
  #   type "pkg"
  #   package_id "com.apple.pkg.JavaForMacOSX107"
  #   checksum dmg_checksum
  # end
when 'windows'
  # inspiration from https://chocolatey.org/packages/jdk8
  java_home = node['java_se']['java_home']
  if java_home.nil? || java_home.empty?
    program_files = arch == 'x64' ? ENV['ProgramW6432'] : ENV['ProgramFiles(x86)']
    java_home = "#{program_files}\\Java\\jdk#{node['java_se']['version']}"
  else
    install_dir = "INSTALLDIR=\"#{java_home}\""
  end

  unless ::File.exist?(java_home)
    ruby_block "install #{::File.basename(file_cache_path)} to #{java_home}" do
      block do
        exec = Mixlib::ShellOut.new("start \"\" /wait \"#{file_cache_path}\""\
          " /s ADDLOCAL=\"#{node['java_se']['win_addlocal']}\" #{install_dir} & exit %%%%ERRORLEVEL%%%%")
        exec.run_command
        exec.error!
      end
    end
  end

  env 'JAVA_HOME' do
    value java_home
  end

  env 'PATH' do
    action :modify
    delim ::File::PATH_SEPARATOR
    value "#{java_home}\\bin"
  end
else
  # recipe_eval do
  #   run_context.include_recipe 'java::default'
  # end
end
