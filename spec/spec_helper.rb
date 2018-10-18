require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '12'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '192'.freeze
HASH = '750e1c8617c5452694857ad95c3ee230'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
