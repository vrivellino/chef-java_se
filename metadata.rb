name 'java_se'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description "Installs Oracle's Java SE JDK"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/dhoer/chef-java_se' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-java_se/issues' if respond_to?(:issues_url)
chef_version '>= 11.0' if respond_to?(:chef_version)
version '8.144.0'

supports 'centos'
supports 'debian'
supports 'fedora'
supports 'mac_os_x'
supports 'redhat'
supports 'ubuntu'
supports 'windows'
