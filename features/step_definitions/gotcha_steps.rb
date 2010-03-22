require 'fileutils'
include FileUtils::Verbose

Given 'a Gotcha program' do
  require 'gotcha'
  @gotcha = Gotcha.new
  @gotcha.finders.clear
end

And /it has repository "(.*)"/ do |url|
  @gotcha.define url
end

And /directory "(.*)" does not exist/ do |path|
  rm_rf(path) if Dir.exist?(path)
end

When /it gets "(.*)"/ do |spec|
  @gotcha.get(spec)
end

Then /file "(.*)" should exist/ do |file|
  File.exist?(file).should == true
end