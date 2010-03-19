require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gotcha'
require 'stringio'

describe "Gotcha" do
  before do
    @gotcha = Gotcha.new
  end
  it 'should have Artifact::Repository::Cache as first repository' do
    @gotcha.finders[0].should be_a Artifact::Finder::FileSystem
  end

  describe 'define an http finder' do
    before do
      @url = 'http://github.com'
      @finder = @gotcha.define(@url)
    end
    describe '"http://github.com"' do
      it 'should return a new rest finder with url' do
        @finder.should be_a Artifact::Finder::Rest
        @finder.url.should == @url
      end

      it 'should have first finder for cache' do
        @finder.cache.should eql(@gotcha.finders.first)
      end

      it 'finder should be last repository' do
        @gotcha.finders.last.should == @finder
      end
    end
  end

  describe 'define a file system finder' do
    it 'should return an Artifact::Finder::FileSystem' do
      @gotcha.define('./tmp').should be_a Artifact::Finder::FileSystem
    end
  end

  describe 'define' do
    it 'should yield added finder' do
      @gotcha.define(@url) do |finder|
        return finder
      end.should eql @gotcha.finders.last
    end
  end
end

describe 'Gotcha.get' do
  before do
    @spec = 'g:i:t:v'
    # given a remote repository, stubbed to return an artifact
    @gotcha = Gotcha.new
    (second = mock).stubs(:get).with(@spec).returns(true)
    @gotcha.finders << second
  end

  it 'should hit second gets when first does not know about spec' do
    @gotcha.finders.first.expects(:get).with(@spec).returns(nil)
    @gotcha.get(@spec).should == true
  end

  it 'should return first when it gets' do
    @gotcha.finders.first.expects(:get).with(@spec).returns('blue')
    @gotcha.get(@spec).should == 'blue'
  end
end