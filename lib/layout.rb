require 'artifact_matcher'

class Layout
  attr_accessor :matcher
  attr_reader :rules

  def initialize
    @matcher = ArtifactMatcher::Default.new
    @rules = []
  end

  def get(spec, &block)
    @rules.push([spec, block])
  end

  def solve(artifact)
    tuple = @rules.find {|t| @matcher.match(t[0], artifact)}
    return tuple[1].call if tuple
  end
end