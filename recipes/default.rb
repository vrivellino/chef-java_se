if node['java_se']['skip']
  Chef::Log.warn('Skipping install of Java SE!')
else
  case node['platform_family']
  when 'mac_os_x'
    include_recipe 'java_se::_macosx_install'
  when 'windows'
    include_recipe 'java_se::_windows_install'
  else
    include_recipe 'java_se::_linux_install'
  end
end
