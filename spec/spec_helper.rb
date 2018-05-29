require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '11'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '172'.freeze
HASH = 'a58eab1ec242421181065cdc37240b08'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
