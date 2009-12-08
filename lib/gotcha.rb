require 'artifact'

class Gotcha
  attr_reader :repositories
  def initialize
    (@repositories = []) << Artifact::Finder::Cache.new 
  end

  def get(spec)
    repositories.each do |r|
      artifact = r.get(spec)
      return artifact if artifact
    end
  end
end