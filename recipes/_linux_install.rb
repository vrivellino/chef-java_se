# inspiration from https://github.com/agileorbit-cookbooks/java
file_cache_path = fetch_java_installer

bin_cmds = node['java_se']['bin_cmds']
default = node['java_se']['set_default']
priority = node['java_se']['alternatives_priority']
owner = node['java_se']['owner']
group = node['java_se']['group']
java_home = node['java_se']['java_home']
java_home = '/usr/lib/jvm/java' if java_home.nil? || java_home.empty?

ruby_block 'set-env-java-home' do
  block do
    ENV['JAVA_HOME'] = java_home
  end
  not_if { ENV['JAVA_HOME'] == java_home }
end

directory '/etc/profile.d' do
  mode '0755'
end

file '/etc/profile.d/jdk.sh' do
  content "export JAVA_HOME=#{java_home}"
  mode '0755'
end

ruby_block 'set JAVA_HOME in /etc/environment' do
  block do
    file = Chef::Util::FileEdit.new('/etc/environment')
    file.insert_line_if_no_match(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
    file.search_file_replace_line(/^JAVA_HOME=/, "JAVA_HOME=#{java_home}")
    file.write_file
  end
  only_if { node['java_se']['set_etc_environment'] }
end

yum_package 'glibc' do
  arch 'i686'
  only_if { platform_family?('rhel', 'fedora') && java_arch == 'i586' }
end

package 'tar'

java_dir_name = "jdk#{java_version}"
java_root = java_home.split('/')[0..-2].join('/')
java_dir = "#{java_root}/#{java_dir_name}"

if default && node['java_se']['use_alt_suffix']
  Chef::Log.debug('processing alternate jdk')
  java_dir = "#{java_dir}_alt"
  java_home = "#{java_home}_alt"
end

ruby_block "adding java to #{java_dir}" do # ~FC014
  block do
    require 'fileutils'

    unless ::File.exist?(java_root)
      FileUtils.mkdir java_root, mode: 0o755
      FileUtils.chown owner, group, java_root
    end

    extract = Mixlib::ShellOut.new(
      %( tar xvzf "#{file_cache_path}" -C "#{Chef::Config[:file_cache_path]}" --no-same-owner)
    )
    extract.run_command
    raise("Failed to extract file #{tarball_name}!") unless extract.exitstatus.zero?

    move = Mixlib::ShellOut.new(%( mv "#{Chef::Config[:file_cache_path]}/#{java_dir_name}" "#{java_dir}" ))
    move.run_command
    unless move.exitstatus.zero?
      raise(%( Command \' mv "#{Chef::Config[:file_cache_path]}/#{java_dir_name}" "#{java_dir}" \' failed ))
    end

    # change ownership of extracted files
    FileUtils.chown_R owner, group, java_root
  end
  not_if { ::File.exist?(java_dir) }
end

# set up .jinfo file for update-java-alternatives
java_name =  java_home.split('/')[-1]
jinfo_file = "#{java_root}/.#{java_name}.jinfo"
template "adding #{jinfo_file} for debian" do
  path jinfo_file
  cookbook 'java_se'
  source 'oracle.jinfo.erb'
  owner owner
  group group
  variables(
    priority: priority,
    bin_cmds: bin_cmds,
    name: java_name,
    java_dir: java_home
  )
  action :create
  only_if { platform_family?('debian') && !::File.exist?(jinfo_file) }
end

link java_home do
  to java_dir
end

# rubocop:disable  Style/Next
ruby_block 'update-alternatives' do # ~FC014
  block do
    alternatives_cmd = node['platform_family'] == 'rhel' ? 'alternatives' : 'update-alternatives'
    bin_cmds.each do |cmd|
      bin_path = "/usr/bin/#{cmd}"
      alt_path = "#{java_home}/bin/#{cmd}"

      unless ::File.exist?(alt_path)
        Chef::Log.info "skipping setting alternative for #{cmd}. Command #{alt_path} does not exist."
        next
      end

      same_prio = Mixlib::ShellOut.new(
        "#{alternatives_cmd} --display #{cmd} | grep #{alt_path} | grep 'priority #{priority}$'"
      )
      same_prio.run_command
      alternative_exists_same_prio = same_prio.exitstatus.zero?
      alt_exists = Mixlib::ShellOut.new("#{alternatives_cmd} --display #{cmd} | grep #{alt_path}")
      alt_exists.run_command
      alternative_exists = alt_exists.exitstatus.zero?
      # remove alternative if priority is changed and install it with new priority
      if alternative_exists && !alternative_exists_same_prio
        Chef::Log.info "removing alternative for #{cmd} with old priority"
        alternative_exists = false
        remove_alt = Mixlib::ShellOut.new("#{alternatives_cmd} --remove #{cmd} #{alt_path}")
        remove_alt.run_command
        unless remove_alt.exitstatus.zero?
          raise("remove alternative failed: #{alternatives_cmd} --remove #{cmd} #{alt_path}")
        end
      end
      # install the alternative if needed
      unless alternative_exists
        Chef::Log.info "adding alternative for #{cmd}"
        if node['java_se']['reset_alternatives']
          Mixlib::ShellOut.new("rm /var/lib/alternatives/#{cmd}").run_command
        end
        install_alt = Mixlib::ShellOut.new("#{alternatives_cmd} --install #{bin_path} #{cmd} #{alt_path} #{priority}")
        install_alt.run_command
        unless install_alt.exitstatus.zero?
          raise("install alternative failed: #{alternatives_cmd} --install #{bin_path} #{cmd} #{alt_path} #{priority}")
        end
      end

      # set the alternative if default
      if default
        set_alt = Mixlib::ShellOut.new(
          "#{alternatives_cmd} --display #{cmd} | grep \"link currently points to #{alt_path}\""
        )
        set_alt.run_command
        unless set_alt.exitstatus.zero?
          Chef::Log.info "setting alternative for #{cmd}"
          set_alt = Mixlib::ShellOut.new("#{alternatives_cmd} --set #{cmd} #{alt_path}")
          set_alt.run_command
          unless set_alt.exitstatus.zero?
            raise("set alternative failed: #{alternatives_cmd} --set #{cmd} #{alt_path}")
          end
        end
      end
    end
  end
  only_if { bin_cmds }
end
# rubocop:enable Style/Next

link '/usr/lib/jvm/default-java' do
  to java_home
  only_if { default && platform_family?('debian') }
end
