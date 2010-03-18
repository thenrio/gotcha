require 'gotcha/artifact_matcher'

class Layout
  attr_accessor :matcher
  attr_reader :rules

  def initialize
    @matcher = Artifact::Matcher.new
    @rules = []
    yield self if block_given?
  end

  def get(spec, &block)
    @rules.push([spec, block])
  end

  def solve(artifact)
    tuple = @rules.find {|tuple| @matcher.match(tuple[0], artifact)}
    return Artifact::Spec.create(artifact).instance_eval &(tuple[1]) if tuple
  end

  class Default < Layout
    def initialize
      super
      get('*') {conventional_path}
    end
  end
end