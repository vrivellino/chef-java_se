default['java_se']['uri'] = nil
default['java_se']['skip'] = false
default['java_se']['force_i586'] = false
default['java_se']['java_home'] = nil

# linux only
default['java_se']['set_default'] = true
default['java_se']['owner'] = 'root'
default['java_se']['group'] = 'root'
default['java_se']['set_etc_environment'] = false
default['java_se']['use_alt_suffix'] = false
default['java_se']['reset_alternatives'] = true
default['java_se']['alternatives_priority'] = 1062
default['java_se']['bin_cmds'] = %w(
  appletviewer apt ControlPanel extcheck idlj jar jarsigner java javac
  javadoc javafxpackager javah javap javaws jcmd jconsole jcontrol jdb
  jdeps jhat jinfo jjs jmap jmc jps jrunscript jsadebugd jstack
  jstat jstatd jvisualvm keytool native2ascii orbd pack200 policytool
  rmic rmid rmiregistry schemagen serialver servertool tnameserv
  unpack200 wsgen wsimport xjc
)

# windows only
default['java_se']['win_addlocal'] = 'ToolsFeature,SourceFeature,PublicjreFeature'
default['java_se']['win_javalink'] = "#{ENV['SYSTEMDRIVE']}\\java\\bin"
default['java_se']['win_jre_home'] = nil
