require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'artifact'

describe "Artifact" do
  #
  # use of matcher enables concise expectation and removes duplication
  #, at the cost of relying on a CUT method : Artifact.to_hash
  # so many spec can break when to_hash will break
  #
  Spec::Matchers.define :have_spec do |spec|
    match do |artifact|
      artifact.to_hash.should == spec
    end
  end

  it "should build out of a string with buildr first convention group:id:type:version" do
    artifact = Artifact::Spec.new('org/github:foo:gem:0.1')
    artifact.should have_spec({:group => 'org/github', :id => 'foo', :type => 'gem',
                               :version => '0.1'})
  end

  it "should build out of a string with buildr second convention group:id:type:classifier:version" do
    artifact = Artifact::Spec.new('org.testng:testng:jar:jdk5:5.9')
    artifact.should have_spec({:group => 'org.testng', :id => 'testng', :type => 'jar',
                               :classifier => 'jdk5', :version => '5.9'})
  end

  it 'should build with one wildcard' do
    artifact = Artifact::Spec.new('*')
    artifact.group.should == '*'
    artifact.id.should be_nil
    artifact.type.should be_nil
    artifact.version.should be_nil   
  end

  it 'should build' do
    artifact = Artifact::Spec.new
    artifact.should have_spec({})
  end

  it "as_hash should return a hash with all specs" do
    artifact = Artifact::Spec.new('g:i:t:v').to_hash.should ==
            {:group => 'g', :id => 'i', :type => 't', :version => 'v'}
  end

  it "as_hash should strip specs having null value" do
    artifact = Artifact::Spec.new('*').to_hash.should ==
            {:group => '*'}
  end

  it 'conventional_path should replace dot to slash in group' do
    Artifact::Spec.new('org.github:foo:gem:0.1').conventional_path.should == 'org/github/foo/0.1/foo-0.1.gem'
  end
end

describe "Artifact.conventional_path" do
  it "should return 'g/i/v/i-v.t' for 'g:i:t:v'" do
    Artifact::Spec.conventional_path('g:i:t:v').should == 'g/i/v/i-v.t'
  end
end

describe 'Artifact::Spec holds installation information' do
  before do
    @spec =  Artifact::Spec.new
  end

  it 'should have mutable uri' do
    @spec.uri.should == nil
    @spec.uri = 'foo'
    @spec.uri.should == 'foo'
  end
end