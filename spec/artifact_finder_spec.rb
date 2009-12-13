require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'artifact_finder'
require 'artifact'
require 'stringio'

describe 'Artifact::Finder.url' do
  it 'should squeeze trailing /' do
    repository = Artifact::Finder.new
    repository.url.should be_nil
    repository.url = 'foo/'
    repository.url.should == 'foo'
    repository.url = 'foo//'
    repository.url.should == 'foo'
  end
end

describe 'Artifact::Finder::Rest' do
  before do
    @finder = Artifact::Finder::Rest.new('http://github.com')
    @spec = 'g:i:t:v'
  end

  it 'should have url' do
    @finder.url.should == 'http://github.com'
  end

  it 'should have a default nil layout' do
    @finder.layout.should be_nil
    @finder.layout = 'git'
    @finder.layout.should == 'git'
  end

  it 'default layout should be nil' do
    @finder.layout.should be_nil
  end

  it 'get should call RestClient to get layouted artifact from base url' do
    (@finder.layout = mock).expects(:solve).with(@spec).returns('blue')
    uri = 'http://github.com/blue'
    content = 'clear'
    RestClient.expects(:get).with(uri).returns(content)
    spec = @finder.get(@spec)
    spec.uri.should == uri
    spec.content.should == content
  end

  it 'put should fail' do
    lambda{@finder.put}.should raise_error(RuntimeError,
                                           'not implemented, and yet, help to spec it is welcome')
  end
end


describe 'Artifact::Finder::Cache' do
  before do
    @finder = Artifact::Finder::Cache.new
    @spec = 'g:i:t:v'
  end

  it 'url should be Artifact::Finder::DefaultLocal' do
    @finder.url.should == Artifact::Finder::Cache::DefaultUrl
  end

  it 'get should return nil when file does not exists' do
    File.expects(:exist?).returns(false)
    @finder.get(@spec).should be_nil
  end

  it 'get should return "#{url}/#{artifact.conventional_path}" when exists' do
    File.expects(:exist?).returns(true)
    @finder.get(@spec).should == "#{@finder.url}/#{Artifact::Spec.conventional_path(@spec)}"
  end

  it 'put should syswrite content to #{url}/#{artifact.conventional_path}' do
    # given a content and a path
    spec = Artifact::Spec.create('g:i:t:v', nil, 'blue')
    target_path = "#{@finder.url}/#{Artifact::Spec.conventional_path(@spec)}"
    # ouch this is long up front expectations
    file = mock
    FileUtils.expects(:mkdir_p).with(File.dirname(target_path))
    File.expects(:open).with(target_path, 'w').yields(file)
    file.expects(:syswrite).with(spec.content)
    # when we put
    spec = @finder.put(spec)
    # then we should have
    spec.uri.should == target_path
    spec.content.should be_nil
  end
end