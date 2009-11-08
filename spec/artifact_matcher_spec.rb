require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'artifact_matcher'

describe "ArtifactMatcher::Default" do
  before do
    @matcher = ArtifactMatcher::Default.new
  end

  it "*:*:*:*should match g:i:t:v" do
    @matcher.match('*:*:*:*', 'g:i:t:v').should be_true
  end

  it "b:*:*:*should not match g:i:t:v" do
    @matcher.match('b:*:*:*', 'g:i:t:v').should be_false
  end
end