require 'serverspec'

set :backend, :cmd
set :os, family: 'windows'

describe file('C:\my\java\jdk\bin\java.exe') do
  it { should be_file }
end

describe file('C:\my\java\jre\bin\java.exe') do
  it { should be_file }
end

describe command('C:\java\bin\java -version') do
  its(:stderr) { should match(/java version \"1.8.0_66\"/m) }
end
