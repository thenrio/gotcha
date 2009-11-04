require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'artifact'

describe "Artifact" do
  it "should build out of a string with buildr first convention group:id:type:version" do
    artifact = Artifact.new('org/github:foo:gem:0.1')
    artifact.group.should == 'org/github'
    artifact.id.should == 'foo'
    artifact.type.should == 'gem'
    artifact.version.should == Gem::Version.new('0.1')
  end
end
