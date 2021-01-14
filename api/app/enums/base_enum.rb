module BaseEnum
  def to_s(key = nil)
    map[key]
  end

  def value_of(name)
    map.key(name.to_s)
  end

  def has?(item = nil)
    map.include? item
  end
end
