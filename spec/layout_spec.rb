require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'layout'

describe "Layout" do
  before do
    @layout = Layout.new
  end

  it "should have default empty rules" do
    @layout.rules.should == []  
  end
end

describe "Layout.rule" do
  before do
    @layout = Layout.new
  end

  it "should have default empty rules" do
    lambda
    @layout.rules.should == []
  end
end

describe "Layout.path" do
  before do
    @layout = Layout.new
  end

  it "should have default empty rules" do
    @layout.rules.should == []
  end

end