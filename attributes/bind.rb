# get details from download_url
# http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz
default['java_se']['release'] = '8'
default['java_se']['update'] = '181'
default['java_se']['build'] = '13'
default['java_se']['hash'] = '96a7b8442fe848ef90c96a2fad6ed6d1'

# https://www.oracle.com/webfolder/s/digest/8u181checksum.html
default['java_se']['sha256']['tar']['i586'] = 'd78a023abffb7ce4aade43e6db64bbad5984e7c82c54c332da445c9a79c1a904'
default['java_se']['sha256']['tar']['x64'] = '1845567095bfbfebd42ed0d09397939796d05456290fb20a83c476ba09f991d3'
default['java_se']['sha256']['dmg']['x64'] = '3ea78e0107f855b47a55414fadaabd04b94e406050d615663d54200ec85efc9b'
default['java_se']['sha256']['exe']['i586'] = '37b090d99104dab7aeae582dbad07731d5550aeb8ebd5eaf0b131e559dd2e30b'
default['java_se']['sha256']['exe']['x64'] = '6d1e254081d56fa460505d5b0f10ce1e33426c44dfbcab838c2be620f35997a4'
