require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gotcha'
require 'stringio'

describe "Gotcha" do
  it 'should have empty repositories' do
    Gotcha.new.repositories.should == []
  end
end

describe 'Gotcha.get' do
  before do
    @gotcha = Gotcha.new
    @spec = 'g:i:t:v'
  end

  it 'should return what first repository that can get will return' do
    # given @gotcha has two repositories, first will fail, second will get true
    (first = mock).expects(:get).with(@spec).returns(nil)
    (second = mock).expects(:get).with(@spec).returns(true)
    @gotcha.repositories << first << second
    # then
    @gotcha.get(@spec).should == true
  end
end