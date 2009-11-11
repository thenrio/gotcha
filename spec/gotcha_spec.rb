require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'gotcha'
describe "Gotcha" do
  before do
    @gotcha = Gotcha.new
  end
  
  it "should have default layout " do
    @gotcha.layout.should be_a Layout
  end

  it "url should chop trailing /" do
    @gotcha.url.should be_nil
    @gotcha.url = 'foo/'
    @gotcha.url.should == 'foo'
    @gotcha.url = 'foo//'
    @gotcha.url.should == 'foo'
  end
end
