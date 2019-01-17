# get details from download_url
# https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.tar.gz
default['java_se']['release'] = '8'
default['java_se']['update'] = '201'
default['java_se']['build'] = '09'
default['java_se']['hash'] = '42970487e3af4f5aa5bca3f542482c60'

# https://www.oracle.com/webfolder/s/digest/8u201checksum.html
default['java_se']['sha256']['tar']['i586'] = '1d31cffe517ef80c8ac1e38a73ec72e6261fe4f3a95f5710e2be30e7f4d043c3'
default['java_se']['sha256']['tar']['x64'] = 'cb700cc0ac3ddc728a567c350881ce7e25118eaf7ca97ca9705d4580c506e370'
default['java_se']['sha256']['dmg']['x64'] = '5b52df4b3efd51480c40ad5abfa18a075365afbb2040bbc5e9f2db568435a6e2'
default['java_se']['sha256']['exe']['i586'] = 'c95830b3e78f5abae26d693d6fb0c16a229f14597f8216b919810b59ad7f752c'
default['java_se']['sha256']['exe']['x64'] = 'bf43f92ab22419a10878638c4fcd559085398233bce6427a89309cab850aab78'
