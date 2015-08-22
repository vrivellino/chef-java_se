# inspiration from https://github.com/agileorbit-cookbooks/java

java_home = node['java_se']['java_home']
java_home = '/usr/lib/jvm/java' if java_home.nil? || java_home.empty?

ruby_block 'set-env-java-home' do
  block do
    ENV['JAVA_HOME'] = java_home
  end
  not_if { ENV['JAVA_HOME'] == java_home }
end

directory '/etc/profile.d' do
  mode 00755
end

file '/etc/profile.d/jdk.sh' do
  content "export JAVA_HOME=#{java_home}"
  mode 00755
end

if node['java_se']['set_etc_environment']
  ruby_block 'Set JAVA_HOME in /etc/environment' do
    block do
      file = Chef::Util::FileEdit.new('/etc/environment')
      file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
      file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
      file.write_file
    end
  end
end

package 'tar'

# java_ark "jdk" do
#   url tarball_url
#   default node['java']['set_default']
#   checksum tarball_checksum
#   app_home java_home
#   bin_cmds bin_cmds
#   alternatives_priority node['java']['alternatives_priority']
#   retries node['java']['ark_retries']
#   retry_delay node['java']['ark_retry_delay']
#   connect_timeout node['java']['ark_timeout']
#   use_alt_suffix node['java']['use_alt_suffix']
#   reset_alternatives node['java']['reset_alternatives']
#   action :install
# end
#
# if node['java']['set_default'] and platform_family?('debian')
#   include_recipe 'java::default_java_symlink'
# end
#
# include_recipe 'java::oracle_jce' if node['java']['oracle']['jce']['enabled']
