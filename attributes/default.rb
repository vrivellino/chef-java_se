default['java_se']['uri'] = nil
default['java_se']['force_i586'] = false

# linux only
default['java_se']['set_etc_environment'] = false
default['java_se']['use_alt_suffix'] = false

# windows only
default['java_se']['win_addlocal'] = 'ToolsFeature,SourceFeature,PublicjreFeature'

# Deprecated attributes that will be removed in Java 9 release
default['java_se']['url'] = nil # deprecated in favor of uri
default['java_se']['java_home'] = nil # deprecated in favor of uri
