Given 'a Gotcha program' do
  require 'gotcha'
  @gotcha = Gotcha.new
end

And /it has repository "(.*)"/ do |url|
  @gotcha.repositories << url
end

And /directory "(.*)" does not exist/ do |path|
  Dir.exist?(path).should_not == true
end

When /it gets "(.*)"/ do |spec|
  @gotcha.get(spec)
end

Then /file "(.*)" should exist/ do |file|
  File.exist?(file).should == true
end