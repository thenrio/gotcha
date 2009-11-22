require 'restclient'

class Repository
  attr_reader :url
  attr_accessor :layout, :local
  def initialize(url=nil)
    @url = url
    @local = "#{ENV['HOME']}/.gotcha"
  end

  def get(artifact, layout)
    RestClient.get(url + '/' + layout.solve(artifact))
  end
end