require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '11'.freeze
VERSION = '9.0.1'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
