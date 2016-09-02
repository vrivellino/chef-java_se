## Getting Involved

New contributors are always welcome, when it doubt please ask questions. We strive to be an open and welcoming
community. Please be nice to one another.

### Coding

* Pick a task:
  * Offer feedback on open [pull requests](https://github.com/dhoer/chef-java_se/pulls).
  * Review open [issues](https://github.com/dhoer/chef-java_se/issues) for things to help on.
  * [Create an issue](https://github.com/dhoer/chef-java_se/issues/new) to start a discussion on additions or features.
* Fork the project, add your changes and tests to cover them in a topic branch.
* Commit your changes and rebase against `dhoer/chef-java_se` to ensure everything is up to date.
* [Submit a pull request](https://github.com/dhoer/chef-java_se/compare/).

### Updating Release

* Create branch e.g., `git checkout -b 8u101`
* Update `CHANGLOG.md`
* Update Java SE JDK version in `README.md` 
* Update build and update version, and checksums in `attributes/bind.rb`
* Update version in `metadata.rb`
* Update BUILD and VERSION_UPDATE in `spec/spec_helper.rb`
* Update VERSION in `test/integration/alt_home/serverspec/spec_helper.rb`
* Update VERSION in `test/integration/default/serverspec/spec_helper.rb`
* Push to GitHub to integration test Linux and Windows
* Merge to macosx branch not overriding .travis.yml e.g.,
    * `git checkout macosx`
    * `git merge --no-commit 8u101`
    * `git reset HEAD .travis.yml`
    * `git checkout -- .travis.yml`
    * `git commit -m 'merged 8u101'`
* Push to GitHub to integration test Mac OS X 
* Merge to master e.g.,
    * `git checkout master`
    * `git merge 8u101`
* Push to GitHub 
* Cut a Release
* Push to supermarket.chef.io

### Non-Coding

* Offer feedback on open [issues](https://github.com/dhoer/chef-java_se/issues).
* Organize or volunteer at events.
