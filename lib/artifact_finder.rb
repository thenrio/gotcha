require 'restclient'
require 'layout'

module Artifact
  class Finder
    attr_reader :url
    attr_accessor :layout, :cache

    def initialize(url=nil)
      self.url = url
    end

    def url=(url)
      (url[-1] == '/' if url) ? self.url=(url.chop) : @url = url
    end

    def get(spec=nil)
    end

    def put(spec)
    end

    def with_cache(cache)
      self.cache=cache
      class << self
        alias_method :get_without_cache, :get unless self.respond_to? :get_without_cache
        def get(spec=nil)
          cache.put(self.get_without_cache(spec))
        end
      end
      self
    end

    class Rest < Finder
      def get(spec)
        spec = Artifact::Spec.create(spec)
        spec.uri = url + '/' + layout.solve(spec)
        spec.content = RestClient.get(spec.uri)
        spec = @cache.put(spec) if cache
        spec
      end

      def put(artifact=nil)
        fail 'not implemented, and yet, help to spec it is welcome'
      end
    end

    class FileSystem < Finder
      DEFAULT_URL=File.expand_path("#{ENV['HOME']}/.gotcha")

      def initialize(url=DEFAULT_URL)
        super(url)
        self.layout=Layout::Default.new
      end

      def get(spec)
        path = "#{url}/#{layout.solve(spec)}"
        return path if File.exist?(path)
        nil
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
