# inspiration from https://github.com/caskroom/homebrew-cask/blob/master/Casks/java.rb

# Note that you may need to stub java_version_on_macosx? method when testing with rspec:
# allow_any_instance_of(Chef::Recipe).to receive(:java_version_on_macosx?).and_return(false)
unless java_version_on_macosx?
  file_cache_path = fetch_java_installer

  version = java_version

  name = "JDK #{node['java_se']['release']} Update #{node['java_se']['update']}"
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

  execute "/usr/bin/sudo /bin/ln -nsf /Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents/Home " \
  '/Library/Java/Home'

  execute '/usr/bin/sudo /bin/mkdir -p ' \
  "/Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents/Home/bundle/Libraries"

  execute "/usr/bin/sudo /bin/ln -nsf /Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents" \
  "/Home/jre/lib/server/libjvm.dylib /Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents" \
  '/Home/bundle/Libraries/libserver.dylib'

  if node['platform_version'].split('.')[1].to_i <= 9 # mavericks or older
    execute '/usr/bin/sudo /bin/rm -rf /System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK'

    execute "/usr/bin/sudo /bin/ln -nsf /Library/Java/JavaVirtualMachines/jdk#{version}.jdk/Contents " \
  '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK'
  end
end
