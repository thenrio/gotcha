require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gotcha'
require 'stringio'

describe "Gotcha" do
  it 'should have Artifact::Repository::Cache as first repository' do
    Gotcha.new.repositories.first.should be_a Artifact::Finder::Cache
  end
end

describe 'Gotcha.get will hit second repository' do
  before do
    @spec = 'g:i:t:v'
    # given @gotcha has two repositories, and second will get true
    @gotcha = Gotcha.new
    (second = mock).expects(:get).with(@spec).returns(true)
    @gotcha.repositories << second
  end

  it 'should return what second gets when first does not' do
    @gotcha.repositories.first.expects(:get).with(@spec).returns(nil)
    @gotcha.get(@spec).should == true
  end

  it 'should return first when it gets' do
    @gotcha.repositories.first.expects(:get).with(@spec).returns('blue')
    @gotcha.get(@spec).should == 'blue'
  end
end