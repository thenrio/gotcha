require 'restclient'

class Repository
  DefaultLocal = "#{ENV['HOME']}/.gotcha"

  attr_reader :url
  attr_accessor :layout, :local
  def initialize(url=nil)
    @url = url
    @local = DefaultLocal
  end

  def get(artifact, layout)
    RestClient.get(url + '/' + layout.solve(artifact))
  end
end