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
    @layout.get('a:*:*:<2') {"version=#{version}"}
    @layout.get('b:*:*:*') {"group=#{group}"}
    @layout.get('c:*:*:*') {"id=#{id}"}
    @layout.get('a:*:*:*') {"type=#{type}"}
  end

  it "should return evaluation of first block that matches" do
    @layout.solve('a:i:n:1').should == 'version=1'
    @layout.solve('a:i:n:2').should == 'type=n'
    @layout.solve('b:a:t:s').should == 'group=b'
    @layout.solve('c:a:t:s').should == 'id=a'
  end

  it "should return nil when no match" do
    @layout.solve('w:h:a:t').should be_nil
  end
end