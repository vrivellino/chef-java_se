name 'java_se'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description "Installs Oracle's Java SE JDK"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '8.51.1'

# supports 'centos'
supports 'mac_os_x'
# supports 'ubuntu'
supports 'windows'

depends 'dmg', '~> 2.0'
