# Changelog

## 8.65.0

- Update 65

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

- Update 60

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
