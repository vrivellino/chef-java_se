# get details from download_url
# http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz
default['java_se']['release'] = '8'
default['java_se']['update'] = '172'
default['java_se']['build'] = '11'
default['java_se']['hash'] = 'a58eab1ec242421181065cdc37240b08'

# https://www.oracle.com/webfolder/s/digest/8u172checksum.html
default['java_se']['sha256']['tar']['i586'] = '0a4310d31246924d5c3cd161b9da7f446acef373e6484452c80de8d8519f5a33'
default['java_se']['sha256']['tar']['x64'] = '28a00b9400b6913563553e09e8024c286b506d8523334c93ddec6c9ec7e9d346'
default['java_se']['sha256']['dmg']['x64'] = '256acd1a6157e8c8d5413ff67eab138b959234c8ce4f25f1bb19aa9ea428e685'
default['java_se']['sha256']['exe']['i586'] = '434d7cbe88e2a28ee37c7345b5d93810c98112908f7dd5a273a0611482898928'
default['java_se']['sha256']['exe']['x64'] = '580bd9a6da5640661c4dc6ebdb3eac451dbc49f23635728116d90a4d164d3a0f'
