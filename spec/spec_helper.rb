require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '08'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '202'.freeze
HASH = '1961070e4c9b4e26a04e7f5a083f551e'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
