require 'rubygems/version'

class Artifact
  attr_reader :group, :id, :type, :version
  def initialize(spec)
    @group, @id, @type, v = spec.split(':')
    @version = Gem::Version.new(v)
  end
end