# Changelog

## 8.121.0 2017-01-18

- Update 8u121

## 8.112.1 2016-12-18

- 8u112 for OSX has a different build number

## 8.112.0 2016-10-18

- Update 8u112

## 8.111.0 2016-10-18

- Update 8u111

## 8.102.1 2016-08-31

- Fix #20 OSX install fails with Operation not permitted on El Capitan
- Fix #19 Gem install of open_uri_redirections can fail on Windows
- Fix #18 Windows fails to install because ENV variables do not exist
- Fix #17 node.set is deprecated and will be removed in Chef 14

## 8.102.0 2016-07-19

- Update 8u102

## 8.101.0 2016-07-19

- Update 8u101

## 8.92.0 2016-04-19

- Update 8u92

## 8.91.0 2016-04-19

- Update 8u91

## 8.77.0 2016-03-29

- Update 8u77

## 8.74.0 2016-02-10

- Update 8u74

## 8.73.0 2016-02-09

- Update 8u73

## 8.72.0 2016-01-19

- Update 8u72

## 8.71.0 2016-01-19

- Update 8u71

## 8.66.2

- Fix #10 Retry download if file checksum is not valid 

## 8.66.1

- Support chef_gem compile_time attribute

## 8.66.0

- Update 8u66

## 8.65.0

- Update 8u65

## 8.60.10

- Fix #5 Add support for changing the public JRE location on Windows (INSTALLDIRPUBJRE argument)

## 8.60.9

- Fix #4 WARN: Cloning resource attributes for env[PATH] from prior resource (CHEF-3694)

## 8.60.8

- Update readme to clarify file extensions supported

## 8.60.7

- Rename java_version_on_osx? method to java_version_on_macosx?

## 8.60.6

- Fix issue with Mac OS X install not using shellout mixlib correctly
- Use %SYSTEMPATH% on Windows
- Use link resource on Windows install

## 8.60.5

- Fix #3 Allow skipping Java install

## 8.60.4

- Add symbolic link to installed Java JDK bin directory on Windows

## 8.60.3

- Remove unnecessary start cmd from windows install
- Add info about script to demo downloading from Oracle and populating an alt website

## 8.60.2

- Tweak readme

## 8.60.1

- Fix #1 URI parameter ignored

## 8.60.0

- Update 8u60

## 8.51.4

- Remove unused dmg dependency

## 8.51.3

- Support Linux installs

## 8.51.2

- Deprecate url and file attributes in favor of uri

## 8.51.1

- Support Mac OS X install

## 8.51.0

- Initial release
