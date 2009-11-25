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
    tuple = @rules.find {|tuple| @matcher.match(tuple[0], artifact)}
    return Artifact.to_artifact(artifact).instance_eval &(tuple[1]) if tuple
  end
end