require 'layout'

class Gotcha
  attr_accessor :url, :layout

  def initialize(url = nil)
    @url = url
    @layout = Layout.new
  end

  def url=(url)
    url[-1] == '/' ? self.url=(url.chop) : @url = url
  end
end