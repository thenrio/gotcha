require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'repository'

describe 'Repository' do
  before do
    @repository = Repository.new('http://github.org')
  end

  it 'should have url' do
    @repository.url.should == 'http://github.org'
  end
end