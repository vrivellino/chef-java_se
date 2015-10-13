# inspiration from https://chocolatey.org/packages/jdk8

java_home = node['java_se']['java_home']
if java_home.nil? || java_home.empty?
  program_files = node['java_se']['arch'] == 'x64' ? ENV['ProgramW6432'] : ENV['ProgramFiles(x86)']
  java_home = "#{program_files}\\Java\\jdk#{node['java_se']['version']}"
else
  install_dir = "INSTALLDIR=\"#{java_home}\""
end

public_jre_home = node['java_se']['public_jre_home']
if public_jre_home.nil? || public_jre_home.empty?
  program_files = node['java_se']['arch'] == 'x64' ? ENV['ProgramW6432'] : ENV['ProgramFiles(x86)']
  public_jre_home = "#{program_files}\\Java\\jre#{node['java_se']['version']}"
else
  jre_install_dir = "/INSTALLDIRPUBJRE=\"#{public_jre_home}\""
end

win_javalink = node['java_se']['win_javalink']

# create each directory in win_javalink path except bin
path = ''
win_javalink[0..win_javalink.rindex('\\') - 1].split('\\').each_with_index do |dir, index|
  if index == 0 && dir.include?(':')
    path = dir
  else
    path = "#{path}\\#{dir}"
    directory path do
      not_if { ::File.exist?(path) }
    end
  end
end

file_cache_path = node['java_se']['file_cache_path']

execute "install #{::File.basename(file_cache_path)} to #{java_home} with JRE #{public_jre_home}" do
  command "\"#{file_cache_path}\" /s ADDLOCAL=\"#{node['java_se']['win_addlocal']}\" #{install_dir} #{jre_install_dir}"
  not_if { ::File.exist?(java_home) }
end

link win_javalink do
  to "#{java_home}\\bin"
end

env 'JAVA_HOME' do
  value java_home
end

env 'Add java_se to path' do
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
  value "#{public_jre_home}\\bin"
end
