require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '12'.freeze
VERSION = '12.0.1'.freeze
HASH = '69cfe15208a647278a19ef0990eea691'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
