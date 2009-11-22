require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'repository'

describe 'Repository' do
  before do
    @repository = Repository.new('http://github.com')
  end

  it 'should have url' do
    @repository.url.should == 'http://github.com'
  end

  it 'should have a default nil layout' do
    @repository.layout.should be_nil
    @repository.layout = 'git'
    @repository.layout.should == 'git'
  end

  it 'should have default ~/.gotcha as default local repository' do
    Repository::DefaultLocal.should == "#{ENV['HOME']}/.gotcha"
    @repository.local.should == Repository::DefaultLocal
  end

  it 'get should call Transport to get layout for artifact on base url' do
    (layout = mock).expects(:solve).with(:color?).returns('blue')
    RestClient.expects(:get).with('http://github.com/blue').returns(true)
    @repository.get(:color?, layout).should be_true
  end
end