require 'rubygems/version'

class Artifact
  attr_reader :group, :id, :type, :version
  def initialize(spec)
    @group, @id, @type, @version = spec.split(':')
  end

  def to_hash()
    hash = {}
    self.instance_variables.each do |v|
      hash[v.to_s.gsub('@','').to_sym] = self.instance_eval(v)
    end
    hash
  end
  
  def Artifact.conventional_path(spec)
  end
end