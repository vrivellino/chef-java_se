require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '11'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '131'.freeze
HASH = 'd54c1d3a095b4ff2b6607d096fa80163'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
