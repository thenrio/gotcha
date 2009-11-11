require 'artifact'

class ArtifactMatcher
  def match(spec, artifact)
    false
  end

  class Default < ArtifactMatcher
    OP = %w{< = >}

    def version_match(spec, version)
      op = (spec =~ /([#{OP.join}]+)/ ? $1 : '==')
      raw_spec = spec.gsub(/#{op}/, '')
      if (Gem::Version.correct?(raw_spec) and Gem::Version.correct?(version)) then
        return Gem::Version.create(raw_spec).send(op, Gem::Version.create(version))
      end
      raw_spec.send(op, version)
    end

    def match(spec, artifact)
      spec_hash_wo_wildcard = Artifact.new(spec).to_hash.delete_if {|k,v| v == '*'}
      artifact_hash = Artifact.new(artifact).to_hash
      spec_hash_wo_wildcard.each do |k,v|
        if(k == :version) then
          return false unless version_match(v, artifact_hash[k])
        else
          return false unless v == artifact_hash[k]
        end
      end
      true
    end
  end
end