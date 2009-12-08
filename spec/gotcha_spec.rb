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
    @gotcha = Gotcha.new
    @spec = 'g:i:t:v'
  end

  it 'should return what first repository that can get will return' do
    # given @gotcha has two repositories, first will fail, second will get true
    @gotcha.repositories.first.expects(:get).with(@spec).returns(nil)
    (second = mock).expects(:get).with(@spec).returns(true)
    @gotcha.repositories << second
    # then
    @gotcha.get(@spec).should == true
  end
end