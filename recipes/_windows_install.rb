# inspiration from https://chocolatey.org/packages/jdk8

java_home = node['java_se']['java_home']
if java_home.nil? || java_home.empty?
  program_files = node['java_se']['arch'] == 'x64' ? ENV['ProgramW6432'] : ENV['ProgramFiles(x86)']
  java_home = "#{program_files}\\Java\\jdk#{node['java_se']['version']}"
else
  install_dir = "INSTALLDIR=\"#{java_home}\""
end

symlink_path = node['java_se']['win_javalink']

path = ''
symlink_path[0..symlink_path.rindex('\\') - 1].split('\\').each_with_index do |dir, index|
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

execute "install #{::File.basename(file_cache_path)} to #{java_home}" do
  command "\"#{file_cache_path}\" /s ADDLOCAL=\"#{node['java_se']['win_addlocal']}\" #{install_dir}"
  not_if { ::File.exist?(java_home) }
  notifies :run, 'execute[remove symlink to bin]', :immediately
  notifies :run, 'execute[create symlink to bin]', :immediately
end

link link do
  to "#{java_home}\\bin"
end

env 'JAVA_HOME' do
  value java_home
end

env 'PATH' do
  action :modify
  delim ::File::PATH_SEPARATOR
  value "#{java_home}\\bin"
end
