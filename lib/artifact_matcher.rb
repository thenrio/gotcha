class ArtifactMatcher
  def match(artifact, spec)
    false
  end

  class Default < ArtifactMatcher
    def match(artifact, spec)
      true
    end
  end
end