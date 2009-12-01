require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'repository'
require 'artifact'
require 'stringio'

describe 'Repository.DefaultLocal' do
  it 'should be ~/.gotcha' do
    Repository::DefaultLocal.should == File.expand_path("#{ENV['HOME']}/.gotcha")
  end
end

describe 'Repository' do
  before do
    @repository = Repository.new('http://github.com')
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

  it 'download should call RestClient to get layouted artifact from base url' do
    (@repository.layout = mock).expects(:solve).with(@spec).returns('blue')
    RestClient.expects(:get).with('http://github.com/blue')
    @repository.get(@spec)
  end

  it "has 'g:i:t:v' should should be true if file local/g/i/v/i-v.t exists" do
    @repository.local = '.'
    File.expects(:exists?).with('./g/i/v/i-v.t').returns(false)
    @repository.has('g:i:t:v').should be_false
    File.expects(:exists?).with('./g/i/v/i-v.t').returns(true)
    @repository.has('g:i:t:v').should be_true
  end

  it 'put should write io to #{local}/#{artifact.conventional_path}' do
    f = StringIO.new(@spec)
    target_path = Artifact.conventional_path(@spec)
    FileUtils.expects(:mkdir_p).with("#{@repository.local}/#{File.dirname(target_path)}")
    FileUtils.expects(:cp).with(f, "#{@repository.local}/#{target_path}")
    @repository.put('g:i:t:v', f)
  end
end

describe 'Repository.url' do
  it 'should squeeze trailing /' do
    repository = Repository.new
    repository.url.should be_nil
    repository.url = 'foo/'
    repository.url.should == 'foo'
    repository.url = 'foo//'
    repository.url.should == 'foo'
  end
end

describe 'Repository::FileSystem' do
  before do
    @repository = Repository::Cache.new
    @spec = 'g:i:t:v'
  end

  it 'get should return nil when file does not exists' do
    File.expects(:exist?).returns(false)
    @repository.get(@spec).should be_nil
  end

  it 'url should be Repository::DefaultLocal' do
    @repository.url.should == Repository::DefaultLocal
  end

  it 'get should return "#{url}/#{artifact.conventional_path}" when exists' do
    expected = "#{@repository.url}/#{Artifact.conventional_path(@spec)}"
    File.expects(:exist?).with(expected).returns(true)
    @repository.get(@spec).should == expected
  end
end