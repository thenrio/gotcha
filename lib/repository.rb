require 'restclient'
require 'fileutils'

class Repository
  DefaultLocal = "#{ENV['HOME']}/.gotcha"

  attr_reader :url
  attr_accessor :layout, :local

  def initialize(url=nil)
    self.url = url
    @local = DefaultLocal
  end

  def url=(url)
    (url[-1] == '/' if url) ? self.url=(url.chop) : @url = url
  end  

  def get(artifact)
    RestClient.get(url + '/' + layout.solve(artifact))
  end

  def put(artifact, file)
    artifact = Artifact.to_artifact(artifact)
    FileUtils.mkdir_p("#{local}/#{File.dirname(artifact.conventional_path)}")
    FileUtils.cp(file, "#{local}/#{artifact.conventional_path}")
  end

  def has(artifact)
    File.exists? "#{local}/#{Artifact.to_artifact(artifact).conventional_path}"
  end

  class FileSystem < Repository
    def get(artifact)
      return nil if not File.exist?('')
    end
  end
end