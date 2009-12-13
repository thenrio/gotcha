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

    def get(spec)
    end

    def put(spec=nil, file=nil)
    end

    class Rest < Finder
      def get(spec)
        spec = Artifact::Spec.create(spec)
        spec.uri = url + '/' + layout.solve(spec)
        spec.content = RestClient.get(spec.uri)
        spec
      end

      def put(artifact=nil, file=nil)
        fail 'not implemented, and yet, help to spec it is welcome'
      end
    end

    class Cache < Finder
      DefaultUrl=File.expand_path("#{ENV['HOME']}/.gotcha")

      def initialize(url=DefaultUrl)
        super(url)
        self.layout=Layout::Default.new
      end

      def get(spec)
        path = "#{url}/#{layout.solve(spec)}"
        return nil if not File.exist?(path)
        path
      end

      def put(spec)
        uri = "#{url}/#{spec.conventional_path}"
        FileUtils.mkdir_p File.dirname(uri)
        File.open(uri, 'w') do |f|
          f.syswrite spec.content
        end
        spec.uri = uri
        spec.content = nil
        spec
      end
    end
  end
end
