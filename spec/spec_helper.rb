require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '13'.freeze
VERSION = '10.0.2'.freeze
HASH = '19aef61b38124481863b1413dce1855f'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
