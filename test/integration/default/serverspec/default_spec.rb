require 'spec_helper'

case os[:family]
when 'windows'
  describe file("C:\\Program Files (x86)\\Java\\jdk#{VERSION}\\bin\\java.exe") do
    it { should be_file }
  end

  describe file("C:\\Program Files (x86)\\Java\\jre#{VERSION}\\bin\\java.exe") do
    it { should be_file }
  end

  describe command('C:\java\bin\java -version') do
    its(:stderr) { should match(/java version \"#{VERSION}\"/m) }
  end
when 'darwin' # mac os x
  describe command('which java') do
    its(:stdout) { should match(%r{/usr/bin/java}) }
  end

  describe command('java -version') do
    its(:stderr) { should match(/java version \"#{VERSION}\"/m) }
  end
else
  describe command('java -version') do
    its(:stderr) { should match(/java version \"#{VERSION}\"/m) }
  end

  describe command('. /etc/profile.d/jdk.sh && echo $JAVA_HOME') do
    its(:stdout) { should match(%r{usr/lib/jvm/java}) }
  end

  # which not installed on centos docker
  unless os[:family] == 'redhat'
    describe command('readlink -f `which jar`') do
      its(:stdout) { should match(%r{/usr/lib/jvm/jdk#{VERSION}/bin/jar}) }
    end
  end
end
