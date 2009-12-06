require 'restclient'

module Artifact
  class Finder
    attr_reader :url
    attr_accessor :layout

    def initialize(url=nil)
      self.url = url
    end

    def url=(url)
      (url[-1] == '/' if url) ? self.url=(url.chop) : @url = url
    end

    def get(artifact)
      RestClient.get(url + '/' + layout.solve(artifact))
    end

    def put(artifact=nil, file=nil)
      fail 'not implemented, and yet, help to implement it is welcome'
    end

    class Cache < Finder
      DefaultUrl=File.expand_path("#{ENV['HOME']}/.gotcha")

      def initialize(url=DefaultUrl)
        super(url)
        self.layout=Layout::Default.new
      end

      def get(artifact)
        path = "#{url}/#{layout.solve(artifact)}"
        return nil if not File.exist?(path)
        path
      end

      def put(artifact, file)
        artifact = Artifact::Spec.create(artifact)
        FileUtils.mkdir_p("#{url}/#{File.dirname(artifact.conventional_path)}")
        FileUtils.cp(file, "#{url}/#{artifact.conventional_path}")
      end
    end
  end
end
