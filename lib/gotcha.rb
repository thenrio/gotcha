require 'gotcha/artifact'
require 'gotcha/artifact_finder'

class Gotcha
  attr_reader :repositories
  def initialize
    (@repositories = []) << Artifact::Finder::FileSystem.new
  end

  def get(spec)
    repositories.each do |r|
      artifact = r.get(spec)
      return artifact if artifact
    end
  end

  def define(url)
    finder = Artifact::Finder::Rest.new(url)
    repositories.push finder
    finder
  end
end