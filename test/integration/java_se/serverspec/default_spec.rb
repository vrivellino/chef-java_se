require 'serverspec_helper'

case os[:family]
when 'windows'
  describe file('C:\Program Files\Java\jdk1.8.0_51\bin\java.exe') do
    it { should be_file }
  end

  describe command('java -version') do
    its(:stderr) { should match(/java version \"1.8.0_51\"/m) }
  end
when 'darwin' # mac os x
  describe command('which java') do
    its(:stdout) { should match(%r{/usr/bin/java}) }
  end

  describe command('java -version') do
    its(:stderr) { should match(/java version \"1.8.0_51\"/m) }
  end
when 'ubuntu'
  describe file('/home/vagrant/foo.txt') do
    it { should be_file }
  end
end
