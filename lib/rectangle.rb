class Rectangle
  attr_reader :x, :y, :width, :height

  def self.from_tag_data(data)
    new(
      BinData::Uint16be::read(data),
      BinData::Uint16be::read(data),
      BinData::Uint16be::read(data),
      BinData::Uint16be::read(data)
    )
  end

  def initialize(x, y, width, height)
    @x, @y, @width, @height = x, y, width, height
  end
end
