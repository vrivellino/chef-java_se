require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '15'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '141'.freeze
HASH = '336fa29ff2bb4ef291e347e091f7f4a7'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
