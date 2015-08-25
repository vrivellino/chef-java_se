# Java SE Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/java_se.svg?style=flat-square)][cookbook]
[![Build Status](http://img.shields.io/travis/dhoer/chef-java_se.svg?style=flat-square)][travis]
[![GitHub Issues](http://img.shields.io/github/issues/dhoer/chef-java_se.svg?style=flat-square)][github]

[cookbook]: https://supermarket.chef.io/cookbooks/java_se
[travis]: https://travis-ci.org/dhoer/chef-java_se
[github]: https://github.com/dhoer/chef-java_se/issues

Installs Oracle's [Java SE JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html).

The next [scheduled](http://www.oracle.com/technetwork/topics/security/alerts-086861.html) critical patch update:

- 20 October 2015

How is this different from [Java](https://github.com/agileorbit-cookbooks/java) cookbook?

- Only supports Oracle's Java SE JDK
- Allows for downloads directly from Oracle on all supported platforms
- Can specify an alternative URI directory to download from
- Easily lock version to Java release '~> 8.0' or to update '~> 8.60.0'
- Lightweight, no cookbook dependencies
- Does not support RPM installations on Linux
         
Note that this cookbook does not yet support JCE Unlimited Strength Jurisdiction Policy Files.
                                                  
## Requirements

- Chef 11 or higher 

### Platforms

- CentOS, Red Hat, Fedora
- Debian, Ubuntu
- Mac OS X
- Windows

## Usage

By adding java_se to a run_list or as a dependency you are accepting the 
[Oracle Binary Code License Agreement for Java SE]
(http://www.oracle.com/technetwork/java/javase/terms/license/index.html).

Windows platform requires a reboot for JAVA_HOME and PATH to be set.

### Attributes

- `node['java_se']['uri']` - The URI to the Java SE JDKs. This can be a URI to a local directory or file, or a remote 
directory or file.  If a directory is provided, it will then automatically assign a file name that best matches 
platform criteria.  The JDK file names must be the same as that found on Oracle's download page. For local 
directories or files, use file:// prefix e.g., 'file:///c:/path/to/jdk.exe'. The file extension must match platform 
e.g. windows=exe, macosx=dmg, linux=tar.gz.  Leave nil to download directly from Oracle. Default `nil`.
- `node['java_se']['force_i586']` - Install i586 Java on x64 machine if true. For Linux and Windows only.
Default `false`.
- `node['java_se']['java_home']` - Alternative java_home location. Leave nil to use default location. For Linux
and Windows only. Default `nil`.
- `node['java_se']['set_default']` - Indicates whether or not you want the JDK installed to be default on the system. 
For Linux only. Default `true`.                
- `node['java_se']['owner']` - The owner of extracted directory. For Linux only. Default `root`. 
- `node['java_se']['group']` - The group of extracted directory. For Linux only. Default `root`. 
- `node['java_se']['alternatives_priority']` - A priority of the alternatives. For Linux only. Default `1061`.
- `node['java_se']['set_etc_environment']` - Optionally sets JAVA_HOME in /etc/environment for. For Linux only. 
Default `false`.
- `node['java_se']['reset_alternatives']` - Whether alternatives is reset.  For Linux only. Default `true`.  
- `node['java_se']['use_alt_suffix']` whether '_alt' suffix is used for none default java install. For Linux only. 
Default `false`. 
- `node['java_se']['bin_cmds']` -  Array of binary commands to symlink /usr/bin to, and set alternative on.  Examples 
are mvn, java, javac, etc. These cmds must be in the bin subdirectory of the extracted folder. Will be ignored if 
set_default is not true.  For Linux only. 
- `node['java_se']['url']` - Deprecated in favor of uri and will be removed in Java 9 release.
- `node['java_se']['file']` - Deprecated in favor of uri and will be removed in Java 9 release.

### Examples
 
Example role to download JDK from alternative location: 

```ruby
name "java_se"
description "Install Java SE"
default_attributes(
  "java_se": {
    "uri": "https://s3.amazonaws.com/mybucket/java/"
  }
)
run_list(
  "recipe[java_se]"
)
```

This will download the JDK that best matches platform criteria e.g., Windows 64-bit with force_i586 flag set to true
will match https://s3.amazonaws.com/mybucket/java/jdk-8u60-windows-i586.exe. Note that JDK file names must be the 
same as that found on Oracle's download page. 

A script to demonstrate how to download JDKs from Oracle and upload them to an alternative location (S3) is 
available [here](https://github.com/dhoer/chef-java_se/wiki/Populate-S3-with-JDKs).

## Versioning

This cookbook does NOT use [SemVer](http://semver.org) for versioning.  

The versioning scheme is RELEASE.UPDATE.MINOR where:

1. RELEASE is the release of Java e.g. 8
2. UPDATE is the Java update e.g. 60
3. MINOR is the *cookbook release for an enhancement or bugfix e.g. 0

*All cookbook releases will strive to be backwards-compatible.

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chef-java_se).
- Report bugs and discuss potential features in
[Github issues](https://github.com/dhoer/chef-java_se/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-java_se/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-java_se/blob/master/LICENSE.md) file
for details.
