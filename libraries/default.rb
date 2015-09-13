def java_version_on_osx?
  cmd = Mixlib::ShellOut.new("pkgutil --pkgs='com.oracle.jdk#{node['java_se']['jdk_version']}'")
  cmd.run_command
  cmd.exitstatus == 0
end
