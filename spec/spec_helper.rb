require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '09'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '201'.freeze
HASH = '42970487e3af4f5aa5bca3f542482c60'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
