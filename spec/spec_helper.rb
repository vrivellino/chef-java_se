require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '10'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '212'.freeze
HASH = '59066701cf1a433da9770636fbc4c9aa'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
