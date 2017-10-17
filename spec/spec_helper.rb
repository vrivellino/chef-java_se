require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '12'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '151'.freeze
HASH = 'e758a0de34e24606bca991d704f6dcbf'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
