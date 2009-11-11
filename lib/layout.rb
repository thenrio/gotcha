require 'artifact_matcher'

class Layout
  attr_accessor :matcher
  attr_reader :rules

  def initialize
    @matcher = ArtifactMatcher.new
    @rules = []
  end

  def get(spec, &block)
    @rules.push([spec, block])
  end

  def solve(artifact)
    tuple = @rules.find {|t| @matcher.match(t[0], artifact)}
    artifact = Artifact.new(artifact) unless artifact.kind_of?(Artifact)
    return artifact.instance_eval &(tuple[1]) if tuple
  end
end