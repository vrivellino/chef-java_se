name 'java_se'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description "Installs Oracle's Java SE JDK"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '8.77.0'

supports 'centos'
supports 'debian'
supports 'fedora'
supports 'mac_os_x'
supports 'redhat'
supports 'ubuntu'
supports 'windows'

source_url 'https://github.com/dhoer/chef-java_se' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-java_se/issues' if respond_to?(:issues_url)
