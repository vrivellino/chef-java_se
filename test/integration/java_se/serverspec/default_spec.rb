require 'serverspec_helper'

case os[:family]
when 'windows'
  describe file('C:\Program Files (x86)\Java\jdk1.7.0_79\bin\java.exe') do
    it { should be_file }
  end

  describe command('C:\java\bin\java -version') do
    its(:stderr) { should match(/java version \"1.7.0_79\"/m) }
  end
when 'darwin' # mac os x
  describe command('which java') do
    its(:stdout) { should match(%r{/usr/bin/java}) }
  end

  describe command('java -version') do
    its(:stderr) { should match(/java version \"1.7.0_79\"/m) }
  end
else
  describe command('java -version') do
    its(:stderr) { should match(/java version \"1.7.0_79\"/m) }
  end

  describe command('. /etc/profile.d/jdk.sh && echo $JAVA_HOME') do
    its(:stdout) { should match(%r{usr/lib/jvm/java}) }
  end

  describe command('readlink -f `which jar`') do
    its(:stdout) { should match(%r{/usr/lib/jvm/jdk1.7.0_79/bin/jar}) }
  end
end
