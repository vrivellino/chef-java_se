default['java_se']['uri'] = nil
default['java_se']['force_i586'] = false

# windows only
default['java_se']['win_addlocal'] = 'ToolsFeature,SourceFeature,PublicjreFeature'

# linux only
default['java_se']['set_etc_environment'] = false
default['java_se']['use_alt_suffix'] = false

default['java_se']['version'] = '1.8.0_51'
default['java_se']['build'] = '16'

# https://www.oracle.com/webfolder/s/digest/8u51checksum.html
default['java_se']['sha256']['dmg']['x64'] = '85ee66d1fdce5244afcbfbfce8dc90582b8c7e3ec8ab4c21e0f4eb390af97832'
default['java_se']['sha256']['exe']['x64'] = 'f01fd26e6c0936a0f928385c61046d6f97eb32c79bf1ec7c11f105ba8147be87'
default['java_se']['sha256']['exe']['i586'] = '2f2f184c2ec22dbe82a5ed03855c5240019788bdff62df9920bcbcbf4fed3a9f'
default['java_se']['sha256']['rpm']['x64'] = '49527b54d8e179c8da3547fbac223e9b1ecb4b5276b47823c466617aec4bb97b'
default['java_se']['sha256']['rpm']['i586'] = '43e74ff6ad73e16c6a9b2a2a83b5ed86de1c7ea439ffe2af716dec857f5c8a9c'
default['java_se']['sha256']['tar']['x64'] = 'd7149012cc51c2cdb8d3a1767825e0dfc36ca0419c3dae56d993cb2732cbeff1'
default['java_se']['sha256']['tar']['i586'] = '3fd43a5d88ea759bf12502980aa956c683d9df058ad25a94914c5890807e9f2b'

# Deprecated attributes that will be removed in Java 9 release
default['java_se']['url'] = nil # deprecated in favor of uri
default['java_se']['java_home'] = nil # deprecated in favor of uri
