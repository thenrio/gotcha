require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gotcha'
describe "Gotcha" do
  it 'should have empty repositories' do
    Gotcha.new.repositories.should == []
  end
end