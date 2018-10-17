# Java SE Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/java_se.svg?style=flat-square)][cookbook]
[![linux](http://img.shields.io/travis/vrivellino/chef-java_se/master.svg?label=linux&style=flat-square)][linux]
[![osx](http://img.shields.io/travis/vrivellino/chef-java_se/macosx.svg?label=macosx&style=flat-square)][osx]
[![win](https://img.shields.io/appveyor/ci/vrivellino/chef-java-se/master.svg?label=windows&style=flat-square)][win]

[cookbook]: https://supermarket.chef.io/cookbooks/java_se
[linux]: https://travis-ci.org/vrivellino/chef-java_se
[osx]: https://travis-ci.org/vrivellino/chef-java_se/branches
[win]: https://ci.appveyor.com/project/vrivellino/chef-java-se

Installs and configures Oracle's
[Java SE JDK 11](http://www.oracle.com/technetwork/java/javase/downloads/index.html).

See [Critical Patch Updates](http://www.oracle.com/technetwork/topics/security/alerts-086861.html)
for next scheduled JDK release.

## Requirements

- Chef 12+

### Platforms

- CentOS, Red Hat, Fedora
- Debian, Ubuntu
- Amazon Linux
- Mac OS X
- Windows

## Usage

By adding java_se to a run list or cookbook you are accepting the
[Oracle Binary Code License Agreement for Java SE](http://www.oracle.com/technetwork/java/javase/terms/license/index.html).

Older versions of Java JDK are no longer publicly available
after a patch update. So it is recommended that you
[download JDK from alternative location](#download-jdk-from-alternative-location),
or [constrain java_se cookbook version](#constrain-java_se-cookbook-version).
Note that the latter solution could result in a failed converge when
a new patch update is released and a matching version of java_se
cookbook is not yet available.  A release of java_se cookbook usually
follows within a day after a patch update.

Windows JAVA_HOME and PATH environment variables are not available
during initial chef-client run. Attribute
`node['java_se']['win_javalink']` provides a symbolic link to installed
Java JDK bin directory and is available during initial chef-client run.

### Examples

#### Download JDK from alternative location

This will download the JDK that best matches platform criteria. Note that JDK file names must be the
same as that found on Oracle's download page.

A script to download JDKs from Oracle and upload them to Amazon S3 is
available [here](https://github.com/vrivellino/chef-java_se/wiki/Populate-S3-with-JDKs).

```ruby
override_attributes(
  "java_se": {
    "uri": "https://s3.amazonaws.com/mybucket/java"
  }
)
```

#### Constrain java_se cookbook version

[Constrain](https://docs.chef.io/cookbook_versions.html#constraints)
version in cookbook to latest Java SE JDK 11.

```ruby
depends 'java_se', '~> 11.0'
```

Constrain version in
[environment](https://docs.chef.io/cookbook_versions.html#environments)
to latest Java SE JDK 11.

```ruby
cookbook 'java_se', '~> 11.0'
```

### Attributes

- `node['java_se']['uri']` - The URI to the Java SE JDKs. If a directory is provided, it will then automatically
assign a file name that best matches platform criteria.  The JDK file names must be the same as that found on
Oracle's download page. Leave nil to download directly from Oracle. Default `nil`.
- `node['java_se']['skip']` - Skips installing Java SE. Default `false`.
- `node['java_se']['java_home']` - Alternative java_home location. Leave nil to use default location. For Linux
and Windows only. Default `nil`.

#### Linux Only
- `node['java_se']['set_default']` - Indicates whether or not you want the JDK installed to be default on the
system. Default `true`.
- `node['java_se']['owner']` - The owner of extracted directory. Default `root`.
- `node['java_se']['group']` - The group of extracted directory. Default `root`.
- `node['java_se']['alternatives_priority']` - A priority of the alternatives. Default `1061`.
- `node['java_se']['set_etc_environment']` - Optionally sets JAVA_HOME in /etc/environment for. Default `false`.
- `node['java_se']['reset_alternatives']` - Whether alternatives is reset. Default `true`.
- `node['java_se']['use_alt_suffix']` whether '_alt' suffix is used for none default java install. Default `false`.
- `node['java_se']['bin_cmds']` -  Array of binary commands to symlink /usr/bin to, and set alternative on.  Examples
are mvn, java, javac, etc. These cmds must be in the bin subdirectory of the extracted folder. Will be ignored if
set_default is not true.

#### Windows Only
- `node['java_se']['win_addlocal']` - JDK features to install. Default `ToolsFeature,SourceFeature`.
- `node['java_se']['win_javalink']` - Symbolic link to Java JDK bin directory. Since Windows PATH and JAVA_HOME
are not available during chef-client run, this provides a way for cookbooks to access the latest installed
version. Default `%SYSTEMDRIVE%\java\bin`.

#### Bind (Do not override)
- `node['java_se']['release']` - The JDK release version.
- `node['java_se']['build']` - The build number.
- `node['java_se']['sha256'][type]` - The checksum to validate the installer with. Where `type` is one of 'dmg',
'exe', or 'tar'.

## Getting Help

- Ask specific questions on
[Stack Overflow](http://stackoverflow.com/questions/tagged/chef+java).
- Report bugs and discuss potential features in
[Github issues](https://github.com/vrivellino/chef-java_se/issues).

## Contributing

Please refer to
[CONTRIBUTING](https://github.com/vrivellino/chef-java_se/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying
[LICENSE](https://github.com/vrivellino/chef-java_se/blob/master/LICENSE.md)
file for details.
