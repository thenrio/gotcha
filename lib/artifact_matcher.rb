require 'artifact'

class ArtifactMatcher
  def match(artifact, spec)
    false
  end

  class Default < ArtifactMatcher
    def match(spec, artifact)
      spec_hash = Artifact.new(spec).to_hash
      artifact_hash = Artifact.new(artifact).to_hash
      match = false
      spec_hash.each do |k,v| 
        return false if(v != '*' and artifact_hash[k] != v)
      end
      true
    end
  end
end