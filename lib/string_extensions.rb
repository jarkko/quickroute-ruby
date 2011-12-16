class String
  def to_b
    BinData::String.new(self).to_binary_s
  end
end
