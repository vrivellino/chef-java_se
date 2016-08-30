# inspiration from https://chocolatey.org/packages/jdk8
file_cache_path = fetch_java_installer

java_home = node['java_se']['java_home']
if java_home.nil? || java_home.empty?
  java_home = "#{win_install_dir}\\Java\\jdk#{java_version}"
else
  install_dir = "INSTALLDIR=\"#{java_home}\""
end

win_jre_home = node['java_se']['win_jre_home']
if win_jre_home.nil? || win_jre_home.empty?
  win_jre_home = "#{win_install_dir}\\Java\\jre#{java_version}"
else
  jre_install_dir = "/INSTALLDIRPUBJRE=\"#{win_jre_home}\""
end

execute "install #{::File.basename(file_cache_path)} to #{java_home} with JRE #{win_jre_home}" do
  command "\"#{file_cache_path}\" /s ADDLOCAL=\"#{node['java_se']['win_addlocal']}\" #{install_dir} #{jre_install_dir}"
  not_if { ::File.exist?(java_home) }
end

win_javalink = node['java_se']['win_javalink']
javalink_dir = win_javalink[0..win_javalink.rindex('\\') - 1]

# create each directory in win_javalink path except bin (the last path element)
directory javalink_dir do
  recursive true
  not_if { ::File.exist?(path) }
end

link win_javalink do
  to "#{java_home}\\bin"
end

env 'JAVA_HOME' do
  value java_home
end

env 'JRE_HOME' do
  value win_jre_home
end

env 'Add java_se JDK to path' do
  key_name 'PATH'
  action :modify
  delim ::File::PATH_SEPARATOR
  value "#{java_home}\\bin"
end

# JRE is supposed to come before the JDK on the stock path install. Since chef prepends, JRE env resource comes second.
env 'Add java_se JRE to path' do
  key_name 'PATH'
  action :modify
  delim ::File::PATH_SEPARATOR
  value "#{win_jre_home}\\bin"
end
