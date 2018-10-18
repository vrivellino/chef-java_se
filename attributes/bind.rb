# get details from download_url
# http://download.oracle.com/otn-pub/java/jdk/8u192-b12/750e1c8617c5452694857ad95c3ee230/jdk-8u192-linux-x64.tar.gz
default['java_se']['release'] = '8'
default['java_se']['update'] = '192'
default['java_se']['build'] = '12'
default['java_se']['hash'] = '750e1c8617c5452694857ad95c3ee230'

# https://www.oracle.com/webfolder/s/digest/8u192checksum.html
default['java_se']['sha256']['tar']['i586'] = '1be1d7669a36f96d90a0856ab1973dedc632bfdfdf27ccb1c2232608b73e26ce'
default['java_se']['sha256']['tar']['x64'] = '6d34ae147fc5564c07b913b467de1411c795e290356538f22502f28b76a323c2'
default['java_se']['sha256']['dmg']['x64'] = '7ddd3eebbad1c723670d76fb384724c5829a7fcf7c01ea538f78b82ee4ababcc'
default['java_se']['sha256']['exe']['i586'] = 'd4d5bcfd8e3318de9d22fd7f6f1f71df44ce4084e7ff31407492889ef600f1a2'
default['java_se']['sha256']['exe']['x64'] = '588d0882646eaf43b6ac9e40e7de4fb6045632ce49158521980cc632d42032cd'
