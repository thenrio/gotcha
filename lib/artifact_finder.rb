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
        RestClient.get(url + '/' + layout.solve(spec))
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

      def put(spec, file)
        spec = Artifact::Spec.create(spec)
        FileUtils.mkdir_p("#{url}/#{File.dirname(spec.conventional_path)}")
        FileUtils.cp(file, "#{url}/#{spec.conventional_path}")
      end
    end
  end
end
