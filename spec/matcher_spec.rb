require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'artifact_matcher'

describe "ArtifactMatcher::Default" do
  before do
    @matcher = ArtifactMatcher::Default.new
  end

  it "a:b:c:v should match *:*:*:*" do
    @matcher.match('a:b:c:v', '*:*:*:*').should be_true
  end
end