require 'chefspec'
require 'chefspec/berkshelf'

BUILD = '01'.freeze
VERSION_MAJOR = '8'.freeze
VERSION_UPDATE = '144'.freeze
HASH = '090f390dda5b47b9b721c7dfaa008135'.freeze

CACHE = Chef::Config[:file_cache_path]

ChefSpec::Coverage.start!
