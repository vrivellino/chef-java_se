require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '13'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '121'.freeze
HASH = 'e9e7ea248e2c4826b92b3f075a80e441'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
