require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '16'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '152'.freeze
HASH = 'aa0333dd3019491ca4f6ddbe78cdb6d0'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
