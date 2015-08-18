extend Chef::Mixin::ShellOut

# inspiration from https://chocolatey.org/packages/jdk8
java_home = node['java_se']['java_home']
if java_home.nil? || java_home.empty?
  program_files = node['java_se']['arch'] == 'x64' ? ENV['ProgramW6432'] : ENV['ProgramFiles(x86)']
  java_home = "#{program_files}\\Java\\jdk#{node['java_se']['version']}"
else
  install_dir = "INSTALLDIR=\"#{java_home}\""
end

file = node['java_se']['file']
ruby_block "install #{::File.basename(file)} to #{java_home}" do
  block do
    shell_out!("start \"\" /wait \"#{file}\""\
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
