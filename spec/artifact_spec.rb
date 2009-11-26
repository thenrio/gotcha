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

  it "should build out of a string with buildr second convention group:id:type:classifier:version" do
    artifact = Artifact.new('org.testng:testng:jar:jdk5:5.9')
    artifact.group.should == 'org.testng'
    artifact.id.should == 'testng'
    artifact.type.should == 'jar'
    artifact.classifier.should == 'jdk5'
    artifact.version.should == '5.9'
  end

  it "as_hash should return a hash with all specs" do
    artifact = Artifact.new('g:i:t:v').to_hash.should == {:group => 'g', :id => 'i', :type => 't', :version => 'v'}
  end

  it 'conventional_path should replace dot to slash in group' do
    Artifact.new('org.github:foo:gem:0.1').conventional_path.should == 'org/github/foo/0.1/foo-0.1.gem'
  end
end

describe "Artifact.conventional_path" do
  it "should return 'g/i/v/i-v.t' for 'g:i:t:v'" do
    Artifact.conventional_path('g:i:t:v').should == 'g/i/v/i-v.t'
  end
end
