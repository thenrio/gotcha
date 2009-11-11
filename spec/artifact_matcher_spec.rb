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

  it "g:i:t:! should not match g:i:t:v" do
    @matcher.match('g:i:t:!', 'g:i:t:v').should be_false
  end

  it "g:i:t:>=1 should match g:i:t:1" do
    @matcher.match('g:i:t:>=1', 'g:i:t:1').should be_true
  end

  it "g:i:t:<2 should match g:i:t:1" do
    @matcher.match('g:i:t:<2', 'g:i:t:1').should be_true
  end
end