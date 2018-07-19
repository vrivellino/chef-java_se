require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '13'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '181'.freeze
HASH = '96a7b8442fe848ef90c96a2fad6ed6d1'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
