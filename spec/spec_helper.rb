require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '13'.freeze
VERSION = '11.0.1'.freeze
HASH = '90cf5d8f270a4347a95050320eef3fb7'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
