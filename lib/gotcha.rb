require 'artifact'
require 'artifact_finder'

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

  class Artifact::Finder::Rest
        alias_method :get_without_cache_feature, :get
        def get(spec)
          @repositories.first.put(get_without_cache_feature(spec))
        end
        #alias_method :get, :get_with_cache_feature
  end   