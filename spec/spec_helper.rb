require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '11'.freeze
VERSION = '9.0.4'.freeze
HASH = 'c2514751926b4512b076cc82f959763f'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
