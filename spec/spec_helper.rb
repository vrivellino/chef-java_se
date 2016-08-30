require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '14'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '102'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
