require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '10'.freeze
VERSION = '10.0.1'.freeze
HASH = 'fb4372174a714e6b8c52526dc134031e'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
