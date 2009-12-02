require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'artifact_uri'
require 'artifact'
require 'stringio'

describe 'Repository' do
  before do
    @repository = Artifacturi.new('http://github.com')
    @spec = 'g:i:t:v'
  end

  it 'should have url' do
    @repository.url.should == 'http://github.com'
  end

  it 'should have a default nil layout' do
    @repository.layout.should be_nil
    @repository.layout = 'git'
    @repository.layout.should == 'git'
  end

  it 'default layout should be nil' do
    @repository.layout.should be_nil
  end

  it 'get should call RestClient to get layouted artifact from base url' do
    (@repository.layout = mock).expects(:solve).with(@spec).returns('blue')
    RestClient.expects(:get).with('http://github.com/blue')
    @repository.get(@spec)
  end

  it 'put should fail' do
    lambda{@repository.put}.should raise_error(RuntimeError,
                                       'not implemented, and yet, help to implement it is welcome')
  end
end

describe 'Repository.url' do
  it 'should squeeze trailing /' do
    repository = Artifacturi.new
    repository.url.should be_nil
    repository.url = 'foo/'
    repository.url.should == 'foo'
    repository.url = 'foo//'
    repository.url.should == 'foo'
  end
end

describe 'Repository::FileSystem' do
  before do
    @repository = Artifacturi::Cache.new
    @spec = 'g:i:t:v'
  end

  it 'url should be Repository::DefaultLocal' do
    @repository.url.should == Artifacturi::Cache::DefaultUrl
  end

  it 'get should return nil when file does not exists' do
    File.expects(:exist?).returns(false)
    @repository.get(@spec).should be_nil
  end

  it 'get should return "#{url}/#{artifact.conventional_path}" when exists' do
    File.expects(:exist?).returns(true)
    @repository.get(@spec).should == "#{@repository.url}/#{Artifact.conventional_path(@spec)}"
  end

   it 'put should write io to #{url}/#{artifact.conventional_path}' do
    f = StringIO.new(@spec)
    target_path = Artifact.conventional_path(@spec)
    FileUtils.expects(:mkdir_p).with("#{@repository.url}/#{File.dirname(target_path)}")
    FileUtils.expects(:cp).with(f, "#{@repository.url}/#{target_path}")
    @repository.put('g:i:t:v', f)
  end
end