require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'gotcha/artifact_finder'
require 'gotcha/artifact'
require 'stringio'

describe 'Artifact::Finder' do
  before do
    @finder = Artifact::Finder.new
    @spec = 'g:i:t:v'
  end

  it 'should have default layout' do
    @finder.layout.should be_a Layout::Default
  end

  describe 'url' do
    it 'should squeeze trailing /' do
      @finder.url.should be_nil
      @finder.url = 'foo/'
      @finder.url.should == 'foo'
      @finder.url = 'foo//'
      @finder.url.should == 'foo'
    end
  end

  describe 'with_cache' do
    before do
      @cache = mock
      @cache.stubs(:put).returns(:green)
      
      @finder.should_not respond_to :get_without_cache
      @finder.get(@spec).should be_nil
                                        
      @finder.with_cache @cache
    end

    it 'should add method get_without_cache to self' do
      @finder.should respond_to :get_without_cache
      @finder.class.should_not respond_to :get_without_cache
    end

    it 'get should return what cache puts with aliased method' do
      @finder.get(@spec).should == :green
    end

    it 'should be idempotent' do
      @finder.with_cache(@cache)
      @finder.get(@spec).should == :green
    end
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

  describe 'get' do
    before do
      (@finder.layout = mock).stubs(:solve).returns('blue')
      @uri = 'http://github.com/blue'
      @content = 'clear'
      RestClient.expects(:get).with(@uri).returns(@content)
    end

    it 'should call RestClient to get layouted artifact from base url' do
      spec = @finder.get(@spec)
      spec.uri.should == @uri
      spec.content.should == @content
    end
  end


  it 'put should fail' do
    lambda{@finder.put}.should raise_error(RuntimeError,
                                           'not implemented, and yet, help to spec it is welcome')
  end
end


describe 'Artifact::Finder::FileSystem' do
  before do
    @finder = Artifact::Finder::FileSystem.new
    @spec = 'g:i:t:v'
  end

  it 'url should be Artifact::Finder::DefaultLocal' do
    @finder.url.should == Artifact::Finder::FileSystem::DEFAULT_URL
  end

  it 'get should return nil when file does not exists' do
    File.expects(:exist?).returns(false)
    @finder.get(@spec).should be_nil
  end

  it 'get should return "#{url}/#{artifact.conventional_path}" when exists' do
    File.expects(:exist?).returns(true)
    @finder.get(@spec).should == "#{@finder.url}/#{Artifact::Spec.conventional_path(@spec)}"
  end


  describe 'put' do
    before do
      # given a content and a path
      @artifact = Artifact::Spec.create('g:i:t:v')
      @artifact_path = "#{@finder.url}/#{Artifact::Spec.conventional_path(@spec)}"
      # ouch this is long up front expectations
      file = mock
      FileUtils.expects(:mkdir_p).with(File.dirname(@artifact_path))
      File.expects(:open).with(@artifact_path, 'w').yields(file)
      file.expects(:syswrite).with(@artifact.content)
    end
    
    it 'put should syswrite content to #{url}/#{artifact.conventional_path}, in order to preserve binary data' do
      # when we put
      artifact = @finder.put(@artifact)
      # then we should have
      artifact.uri.should == @artifact_path
      artifact.content.should be_nil
    end
  end
end