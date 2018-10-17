name 'java_se'
maintainer 'Vincent Rivellino'
maintainer_email 'github@vince-riv.io'
license 'MIT'
description "Installs Oracle's Java SE JDK"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/vrivellino/chef-java_se' if respond_to?(:source_url)
issues_url 'https://github.com/vrivellino/chef-java_se/issues' if respond_to?(:issues_url)
chef_version '>= 12.1' if respond_to?(:chef_version)
version '11.0.1'

supports 'centos'
supports 'debian'
supports 'fedora'
supports 'mac_os_x'
supports 'redhat'
supports 'ubuntu'
supports 'windows'
supports 'amazon'
