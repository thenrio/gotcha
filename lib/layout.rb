class Layout
  def rules
    @rules ||= []
  end

  def rule(&block)
    @rules.push block
  end
end