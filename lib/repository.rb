class Repository
  attr_reader :url
  def initialize(url=nil)
    @url = url  
  end
end