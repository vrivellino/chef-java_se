# get details from download_url
# http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz
default['java_se']['release'] = '8'
default['java_se']['update'] = '172'
default['java_se']['build'] = '11'
default['java_se']['hash'] = 'a58eab1ec242421181065cdc37240b08'

# https://www.oracle.com/webfolder/s/digest/8u172checksum.html
default['java_se']['sha256']['tar']['i586'] = '0a4310d31246924d5c3cd161b9da7f446acef373e6484452c80de8d8519f5a33'
default['java_se']['sha256']['tar']['x64'] = '28a00b9400b6913563553e09e8024c286b506d8523334c93ddec6c9ec7e9d346'
default['java_se']['sha256']['dmg']['x64'] = 'b0de04d3ec7fbf2e54e33e29c78ababa0a4df398ba490d4abb125b31ea8d663e'
default['java_se']['sha256']['exe']['i586'] = '63c66282303df19060b476b583f8bc21a88afcf63f669d56c4e966751ec9181c'
default['java_se']['sha256']['exe']['x64'] = '0b330b00576420a38f5c76cd07899b46551c075fa9e4df6028b14828e538e30d'
