# Testing java_se cookbook

This cookbook includes both unit tests via
[ChefSpec](https://github.com/sethvargo/chefspec) and integration tests
via [Test Kitchen](https://github.com/test-kitchen/test-kitchen).

Contributions to this cookbook will only be accepted if all tests pass
successfully:

```bash
chef exec rake
kitchen verify
```

## Setting up the test environment

Install the latest version of
[Vagrant](http://www.vagrantup.com/downloads.html) and
[VirtualBox](https://www.virtualbox.org/wiki/Downloads).

The Chef tooling (chefspec/test kitchen/etc) is managed by the
[Chef Development Kit](http://downloads.getchef.com/chef-dk/).

Clone the latest version of the cookbook from the repository.

```bash
git clone git@github.com:dhoer/chef-java_se.git java_se
cd java_se
```

## Running ChefSpec

ChefSpec unit tests are located in `spec`.
Your new functionality or bug fix should have corresponding test
coverage - if it's a change, make sure it doesn't introduce a regression
(existing tests should pass). If it's a change or introduction of new
functionality, add new tests as appropriate.

To run ChefSpec for the whole cookbook:

`chef exec rake`

To run ChefSpec for a specific recipe:

`chef exec rspec spec/unit/linux_spec.rb`

## Running Test Kitchen

Test Kitchen test suites are defined in
[.kitchen.yml](https://github.com/agileorbit-cookbooks/java/blob/master/.kitchen.yml).
Running `kitchen verify` will cause Test Kitchen to spin up each
platform VM in turn, running the `java_se::default` recipe with
differing parameters in order to test all possible combinations of
platform, install_flavor, and JDK version. If the Chef run completes
successfully, corresponding tests in `test/integration` are executed.
These must also pass.