require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'artifact'

describe "Artifact" do
  it "should build out of a string with buildr first convention group:id:type:version" do
    artifact = Artifact.new('org/github:foo:gem:0.1')
    artifact.group.should == 'org/github'
    artifact.id.should == 'foo'
    artifact.type.should == 'gem'
    artifact.version.should == '0.1'
  end

  it "as_hash should return a hash with all specs" do
    artifact = Artifact.new('g:i:t:v').to_hash.should == {:group => 'g', :id => 'i', :type => 't', :version => 'v'}
  end
end

describe "Artifact.convential_path" do
  it "should return buildr first convention group:id:type:version" do
    Artifact.conventional_path('g:i:t:v').should == 'g/i/v/i-v.t'
  end
end
