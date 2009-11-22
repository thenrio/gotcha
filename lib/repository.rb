require 'restclient'
require 'fileutils'

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

  def put(artifact, file)
    artifact = Artifact.new(artifact) unless artifact.kind_of? Artifact
    FileUtils.mkdir_p(@local+'/'+File.dirname(artifact.conventional_path))
    FileUtils.cp(file, @local+'/'+artifact.conventional_path)
  end
end