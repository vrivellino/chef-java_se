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

The Chef tooling (chefspec/test kitchen/etc) is managed by the
[Chef Development Kit](http://downloads.getchef.com/chef-dk/).

Clone the latest version of the cookbook from the repository.

```bash
git clone git@github.com:vrivellino/chef-java_se.git java_se
cd java_se
bundle install
```

### AWS

To utilize AWS EC2 via the [kitchen-ec2](https://github.com/test-kitchen/kitchen-ec2/), you'll need AWS API access
configured in a [standard way](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).

A security group named with a `Name` tag of `test-kitchen` must be created with ports 22, 5985, and 5986 open
to your IP address. That security group should be in your Default VPC.

### Vagrant

Alternativately, you can install the latest versions of
[Vagrant](http://www.vagrantup.com/downloads.html) and
[VirtualBox](https://www.virtualbox.org/wiki/Downloads).

Set the environment variable `KITCHEN_YAML` to `.kitchen.vagrant.yml`.

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

Test Kitchen test suites are defined in `.kitchen.yml`.
Running `kitchen verify` will cause Test Kitchen to spin up each
platform VM in turn, running the `java_se::default` recipe with
differing parameters in order to test all possible combinations of
platform, install_flavor, and JDK version. If the Chef run completes
successfully, corresponding tests in `test/integration` are executed.
These must also pass.
