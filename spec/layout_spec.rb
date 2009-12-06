require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'layout'

describe "Layout" do
  before do
    @layout = Layout.new
  end

  it "should have default empty rules" do
    @layout.rules.should == []  
  end

  it "should have default Artifact::Matcher" do
    @layout.matcher.should be_instance_of Artifact::Matcher
  end
end

describe "Layout.solve" do
  before do
    @layout = Layout.new
  end

  it "should return first block that matches" do
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

describe 'Layout.new' do
  it 'should yield self' do
    actual = nil
    expected = Layout.new {|l| actual = l}
    actual.should == expected
  end
end

describe 'Layout::Default' do
  before do
    @layout = Layout::Default.new
  end

  def should_be_conventional_path(spec)
    @layout.solve(spec).should == Artifact::Spec.conventional_path(spec)
  end

  it 'should return conventional path for any artifact' do
    should_be_conventional_path 'w:h:a:t'
    should_be_conventional_path 'w:a:z:z:a'
  end
end