class Gotcha
  def repositories
    @repositories ||= []
  end

  def get(spec)
    repositories.each do |r|
      artifact = r.get(spec)
      return artifact if artifact
    end
  end
end