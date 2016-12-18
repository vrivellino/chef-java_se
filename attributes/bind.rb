default['java_se']['release'] = '8'
default['java_se']['update'] = '112'
default['java_se']['build'] = if platform?('mac_os_x') ? '16' : '15'

# https://www.oracle.com/webfolder/s/digest/8u112checksum.html
default['java_se']['sha256']['tar']['i586'] = '1e7c2fb80b339dd65f261d37e26ffd5f3136e5ff8778026ed227b47516df69a5'
default['java_se']['sha256']['tar']['x64'] = '777bd7d5268408a5a94f5e366c2e43e720c6ce4fe8c59d9a71e2961e50d774a5'
default['java_se']['sha256']['dmg']['x64'] = 'c9ebb729acb0ee8e6fbeda85751be20b024c45e3ebb83cc7c624908ffb8a466d'
default['java_se']['sha256']['exe']['i586'] = 'c2126bb16b85ee47f44124d318155c329194e1a60a3a5562a6a4672ca5989c85'
default['java_se']['sha256']['exe']['x64'] = '6c3504185dd06f50b0578766bd913b277fd1ff444023aacd20b969ae76f20f5e'
