# Java SE Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/java_se.svg?style=flat-square)][cookbook]
[![Build Status](http://img.shields.io/travis/dhoer/chef-java_se.svg?style=flat-square)][travis]
[![GitHub Issues](http://img.shields.io/github/issues/dhoer/chef-java_se.svg?style=flat-square)][github]

[cookbook]: https://supermarket.chef.io/cookbooks/java_se
[travis]: https://travis-ci.org/dhoer/chef-java_se
[github]: https://github.com/dhoer/chef-java_se/issues

Installs Oracle's [Java SE JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html).

The next scheduled critical patch update:

- 20 October 2015
                                                  
## Requirements

- Chef 11 or higher 

### Platforms

- CentOS
- Mac OS X
- Ubuntu
- Windows

## Usage

By adding java_se to a run_list or as a dependency you are accepting the 
[Oracle Binary Code License Agreement for Java SE]
(http://www.oracle.com/technetwork/java/javase/terms/license/index.html).

### Attributes

- `node['java_se']['url']` - The URL which to download the Java SE JDKs. Leave `nil` to download directly from Oracle.
Default is `nil`.
- `node['java_se']['32bit_only']` - Install 32-bit Java on 64-bit machines if `true`. For Linux and Windows only.
Default is `false`.
- `node['java_se']['tar_only']` - Install tar on debian platform instead of rpm. For Debian platforms only.
Default is `false`.

### Examples

#### Configure java_se to download JDKs from s3 instead of Oracle: 

```ruby
{ 
  "java_se": {
    "url": 'https://s3.amazonaws.com/mybucket/java/'
  }
  ...
}
```

This will look for a JDK that best matches platform family e.g., windows 64-bit will match 
https://s3.amazonaws.com/mybucket/java/jdk-8u51-windows-x64.exe.
Note that the JDK file names must be the same as on Oracle's download page. 


## Versioning

This cookbook does NOT use [SemVer](http://semver.org) for versioning.  

The versioning scheme is RELEASE.UPDATE.PATCH where:

1. RELEASE is the release of Java e.g. 8
2. UPDATE is the Java critical patch update e.g. 51
3. PATCH is the cookbook release for the update e.g. 0


## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chef-java_se).
- Report bugs and discuss potential features in
[Github issues](https://github.com/dhoer/chef-java_se/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-java_se/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-java_se/blob/master/LICENSE.md) file
for details.
