require 'rubygems/version'

module Artifact
  class Spec
    attr_reader :group, :id, :type, :classifier, :version
    attr_accessor :uri, :content
    
    def initialize(spec={})
      case spec
        when Hash
          return
        else
          initialize_from_string(spec)
      end
    end

    def initialize_from_string(spec)
      spec_array = spec.split(':')
      if spec_array.length == 4
        @group, @id, @type, @version = spec_array
      else
        @group, @id, @type, @classifier, @version = spec_array
      end
    end
    private :initialize_from_string

    def to_hash()
      hash = {}
      self.instance_variables.each do |v|
        value = self.instance_eval(v)
        hash[v.to_s.gsub('@', '').to_sym] = value if value
      end
      hash
    end

    def conventional_path()
      "#{group.gsub('.', '/')}/#{id}/#{version}/#{id}-#{version}.#{type}"
    end

    def self.conventional_path(spec)
      Spec.create(spec).conventional_path
    end

    def self.create (spec, uri=nil, content=nil)
      spec = Spec.new(spec) unless spec.kind_of? Spec
      spec.uri = uri
      spec.content = content
      spec
    end
  end
end
