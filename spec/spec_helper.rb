require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '7'.freeze
VERSION = '11.0.2'.freeze
HASH = 'f51449fcd52f4d52b93a989c5c56ed3c'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
