require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'layout'

describe "Layout" do
  before do
    @layout = Layout.new
  end

  it "should have default empty rules" do
    @layout.rules.should == []  
  end

  it "should have default ArtifactMatcher" do
    @layout.matcher.should be_instance_of ArtifactMatcher::Default
  end
end

describe "Layout.solve" do
  before do
    @layout = Layout.new
    @layout.get('a:*:*:*') {1}
    @layout.get('b:*:*:*') {2}
    @layout.get('c:*:*:*') {3}
  end

  it "should return first block that matches" do
    @layout.solve('a:i:n:1').should == 1
    @layout.solve('b:a:t:s').should == 2
    @layout.solve('c:a:t:1').should == 3
  end

  it "should return nil when no match" do
    @layout.solve('w:h:a:t').should be_nil
  end
end