class Repository
  attr_reader :url
  attr_accessor :layout
  def initialize(url=nil)
    @url = url  
  end
end