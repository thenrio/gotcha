require 'transport'

class Repository
  attr_reader :url
  attr_accessor :layout
  def initialize(url=nil)
    @url = url  
  end

  def get(artifact, layout)
    Transport.get(url + '/' + layout.solve(artifact))
  end
end