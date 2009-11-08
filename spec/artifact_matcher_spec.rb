require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'artifact_matcher'

describe "ArtifactMatcher::Default" do
  before do
    @matcher = ArtifactMatcher::Default.new
  end

  it "*:*:*:*should match a:b:c:v" do
    @matcher.match('*:*:*:*', 'a:b:c:v').should be_true
  end

  it "b:*:*:*should not match a:b:c:v" do
    @matcher.match('b:*:*:*', 'a:b:c:v').should be_false
  end
end