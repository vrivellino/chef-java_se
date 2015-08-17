extend Chef::Mixin::ShellOut

chef_gem 'open_uri_redirections' do # ~FC009
  version '0.2.1'
  compile_time false
end

arch = node['kernel']['machine'] =~ /x86_64/ ? 'x64' : 'i586'
arch = 'i586' if node['java_se']['force_i586'] && !platform?('mac_os_x')

version = node['java_se']['version']
jdk_version = version.sub(/^\d+\.(\d+).*?_(.*)$/, '\1u\2')
build = node['java_se']['build']

case node['platform_family']
when 'debian', 'rhel', 'fedora'
  jdk = "jdk-#{jdk_version}-linux-#{arch}.tar.gz"
  checksum = node['java_se']['sha256']['tar'][arch]
when 'mac_os_x'
  jdk = "jdk-#{jdk_version}-macosx-#{arch}.dmg"
  checksum = node['java_se']['sha256']['dmg']['x64']
when 'windows'
  jdk = "jdk-#{jdk_version}-windows-#{arch}.exe"
  checksum = node['java_se']['sha256']['exe'][arch]
end

url = node['java_se']['url']
if url.nil? || url.empty?
  download_url = "http://download.oracle.com/otn-pub/java/jdk/#{jdk_version}-b#{build}/#{jdk}"
else
  if %w(.dmg .exe .tar.gz).include?(url)
    download_url = url
    jdk = ::File.basename(url)
  else
    download_url = "#{url}/#{jdk}"
  end
end

file_cache_path = File.join(Chef::Config[:file_cache_path], jdk)

ruby_block "fetch #{download_url}" do
  block do
    JavaSE.fetch(download_url, file_cache_path)
    JavaSE.validate(file_cache_path, checksum)
  end
  not_if { ::File.exist?(file_cache_path) && JavaSE.valid?(file_cache_path, checksum) }
end

case node['platform_family']
when 'mac_os_x'
  # inspiration from https://github.com/caskroom/homebrew-cask/blob/master/Casks/java.rb
  unless shell_out("pkgutil --pkgs='com.oracle.jdk#{jdk_version}'").exitstatus == 0
    name = "JDK #{version.split('.')[1]} Update #{version.sub(/^.*?_(\d+)$/, '\1')}"
    execute "hdiutil attach '#{file_cache_path}' -quiet"

    avoid_daemon = Gem::Version.new(node['platform_version']) >= Gem::Version.new('10.8')
    execute "sudo installer -pkg '/Volumes/#{name}/#{name}.pkg' -target /" do
      # Prevent cfprefsd from holding up hdiutil detach for certain disk images
      environment('__CFPREFERENCES_AVOID_DAEMON' => '1') if avoid_daemon
    end

    execute "hdiutil detach '/Volumes/#{name}' || hdiutil detach '/Volumes/#{name}' -force"

    #
    # make minor modifications to the JRE to prevent issues with packaged applications,
    # as discussed here: https://bugs.eclipse.org/bugs/show_bug.cgi?id=411361
    #

    %w(BundledApp JNI WebStart Applets).each do |str|
      execute "/usr/bin/sudo /usr/libexec/PlistBuddy -c \"Add :JavaVM:JVMCapabilities: string #{str}\" " \
       "/Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents/Info.plist"
    end

    execute '/usr/bin/sudo /bin/rm -rf /System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK'

    execute "/usr/bin/sudo /bin/ln -nsf /Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents " \
      '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK'

    execute "/usr/bin/sudo /bin/ln -nsf /Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents/Home " \
      '/Library/Java/Home'

    execute '/usr/bin/sudo /bin/mkdir -p ' \
      "/Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents/Home/bundle/Libraries"

    execute "/usr/bin/sudo /bin/ln -nsf /Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents" \
      "/Home/jre/lib/server/libjvm.dylib /Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents" \
      '/Home/bundle/Libraries/libserver.dylib'
  end
when 'windows'
  # inspiration from https://chocolatey.org/packages/jdk8
  java_home = node['java_se']['java_home']
  if java_home.nil? || java_home.empty?
    program_files = arch == 'x64' ? ENV['ProgramW6432'] : ENV['ProgramFiles(x86)']
    java_home = "#{program_files}\\Java\\jdk#{node['java_se']['version']}"
  else
    install_dir = "INSTALLDIR=\"#{java_home}\""
  end

  ruby_block "install #{::File.basename(file_cache_path)} to #{java_home}" do
    block do
      shell_out!("start \"\" /wait \"#{file_cache_path}\""\
        " /s ADDLOCAL=\"#{node['java_se']['win_addlocal']}\" #{install_dir} & exit %%%%ERRORLEVEL%%%%")
    end
    not_if { ::File.exist?(java_home) }
  end

  env 'JAVA_HOME' do
    value java_home
  end

  env 'PATH' do
    action :modify
    delim ::File::PATH_SEPARATOR
    value "#{java_home}\\bin"
  end
end
