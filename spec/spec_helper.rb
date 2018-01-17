require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '12'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '162'.freeze
HASH = '0da788060d494f5095bf8624735fa2f1'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
