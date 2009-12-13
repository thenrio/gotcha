require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'artifact_matcher'

describe "Artifact::Matcher" do
  before do
    @matcher = Artifact::Matcher.new
    @spec = 'g:i:t:v'
  end

  it "*:*:*:*should match g:i:t:v" do
    @matcher.match('*:*:*:*', @spec).should be_true
  end

  it "b:*:*:*should not match g:i:t:v" do
    @matcher.match('b:*:*:*', @spec).should be_false
  end

  it "g:i:t:! should not match g:i:t:v" do
    @matcher.match('g:i:t:!', @spec).should be_false
  end

  it "* should match g:i:t:v" do
    @matcher.match('*', @spec).should be_true
  end

  it 'should match against an Artifact::Spec' do
    @matcher.match(@spec, Artifact::Spec.create(@spec)).should be_true
  end
end

describe "Artifact::Matcher.version_match" do
  before do
    @matcher = Artifact::Matcher.new
  end
  
  it ">=1 should 'version match' 1" do
    @matcher.version_match('>=1', '1').should be_true
  end

  it "<2 should 'version match' 1" do
    @matcher.version_match('<2', '1').should be_true
  end

  it "<b should 'version match' a" do
    @matcher.version_match('<b', 'a').should be_true
  end
end
