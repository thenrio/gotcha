require 'artifact_matcher'

class Layout
  attr_accessor :matcher

  def initialize
    @matcher = ArtifactMatcher::Default.new  
  end

  def rules
    @rules ||= []
  end

  def get(spec, &block)
    @rules.push([spec, block])
  end
end