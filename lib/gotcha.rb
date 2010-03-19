require 'gotcha/artifact'
require 'gotcha/artifact_finder'

class Gotcha
  attr_reader :finders
  def initialize
    (@finders = []) << Artifact::Finder::FileSystem.new
  end

  def get(spec)
    finders.each do |finder|
      artifact = finder.get(spec)
      return artifact if artifact
    end
  end

  def define(url)
    finder = Artifact::Finder::Rest.new(url).with_cache(finders.first)
    finders.push(finder)
    finder
  end
end