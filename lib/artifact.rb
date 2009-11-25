require 'rubygems/version'

class Artifact
  attr_reader :group, :id, :type, :classifier, :version

  def initialize(spec)
    spec_array = spec.split(':')
    if spec_array.length == 4
      @group, @id, @type, @version = spec_array
    else
      @group, @id, @type, @classifier, @version = spec_array
    end
  end

  def to_hash()
    hash = {}
    self.instance_variables.each do |v|
      hash[v.to_s.gsub('@', '').to_sym] = self.instance_eval(v)
    end
    hash
  end

  def conventional_path()
    "#{group}/#{id}/#{version}/#{id}-#{version}.#{type}"
  end

  def self.conventional_path(spec)
    Artifact.new(spec).conventional_path
  end
end