require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '15'.freeze
VERSION_MAJOR = '7'.freeze
VERSION_UPDATE = '79'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
