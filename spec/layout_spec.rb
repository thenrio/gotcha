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
    @layout.matcher.should be_instance_of ArtifactMatcher
  end
end

describe "Layout.solve" do
  before do
    @layout = Layout.new
  end

  it "should return of first block that matches" do
    # given the following rules
    @layout.get('a:*:*:<2') {1}
    @layout.get('b:*:*:*') {2}
    @layout.get('c:*:*:*') {3}
    @layout.get('a:*:*:*') {4}

    @layout.solve('a:i:n:1').should == 1
    @layout.solve('b:a:t:s').should == 2
    @layout.solve('c:a:t:s').should == 3
    @layout.solve('a:i:n:2').should == 4
  end

  it 'should evaluate matched block in artifact context' do
    # given a rule with that requires artifact context evaluation
    @layout.get('*:*:*:*') {"#{group} #{id} #{version}.times more than #{type}"}
    @layout.solve('git:rocks:svn:10').should == 'git rocks 10.times more than svn'
  end

  it "should return nil when no match" do
    @layout.solve('w:h:a:t').should be_nil
  end
end