# get details from download_url
# http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz
default['java_se']['release'] = '8'
default['java_se']['update'] = '162'
default['java_se']['build'] = '12'
default['java_se']['hash'] = '0da788060d494f5095bf8624735fa2f1'

# https://www.oracle.com/webfolder/s/digest/8u162checksum.html
default['java_se']['sha256']['tar']['i586'] = 'eecf88dbcf7c78d236251d44350126f1297a522f2eab974b4027ef20f7a6fb24'
default['java_se']['sha256']['tar']['x64'] = '68ec82d47fd9c2b8eb84225b6db398a72008285fafc98631b1ff8d2229680257'
default['java_se']['sha256']['dmg']['x64'] = '56f7c30eb737ab46cbfb2aed925e4df2a3d24c03ce027ae1eb57c50aa0e29d3e'
default['java_se']['sha256']['exe']['i586'] = '4a705bd74171eb003a1485d1b2d7a3fb735452f252d39a7beee5117f08614c1f'
default['java_se']['sha256']['exe']['x64'] = 'f05aa9904c373b2e0aad7a5ce1006aa3aff096842f256d66c6cfc268d9c48026'
