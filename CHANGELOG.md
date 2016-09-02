# Changelog

## 7.79.7

- Fix #20 OSX install fails with Operation not permitted on El Capitan
- Fix #19 Gem install of open_uri_redirections can fail on Windows
- Fix #18 Windows fails to install because ENV variables do not exist
- Fix #17 node.set is deprecated and will be removed in Chef 14

## 7.79.6

- Fix #10 Retry download if file checksum is not valid 

## 7.79.5

- Support chef_gem compile_time attribute

## 7.79.4

- Merged with 8.66.0 install engine

## 7.79.3

- Rename java_version_on_osx? method to java_version_on_macosx?

## 7.79.2

- Fix issue with checksum validation using sha256 instead of md5

## 7.79.1

- Fix issue with Mac OS X install not using shellout mixlib correctly
- Use %SYSTEMPATH% on Windows 
- Use link resource on Windows install

## 7.79.0

- Branched from 8.60.5 to create 7.79.0
