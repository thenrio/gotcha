require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gotcha'
require 'stringio'

describe "Gotcha" do
  it 'should have Artifact::Repository::Cache as first repository' do
    Gotcha.new.repositories.first.should be_a Artifact::Finder::Cache
  end
end

describe 'Gotcha.get' do
  before do
    @spec = 'g:i:t:v'
    # given a remote repository, stubbed to return an artifact
    @gotcha = Gotcha.new
    (second = mock).stubs(:get).with(@spec).returns(true)
    @gotcha.repositories << second
  end

  it 'should hit second gets when first does not know about spec' do
    @gotcha.repositories.first.expects(:get).with(@spec).returns(nil)
    @gotcha.get(@spec).should == true
  end

  it 'should return first when it gets' do
    @gotcha.repositories.first.expects(:get).with(@spec).returns('blue')
    @gotcha.get(@spec).should == 'blue'
  end

  it 'first should put when it is not hit' do
    
  end
end