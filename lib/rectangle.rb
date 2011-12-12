class Rectangle
  attr_reader :x, :y, :width, :height

  def self.from_tag_data(tag_data)
    new(
      BinData::Uint16be::read(tag_data[0,2]),
      BinData::Uint16be::read(tag_data[2,2]),
      BinData::Uint16be::read(tag_data[4,2]),
      BinData::Uint16be::read(tag_data[6,2])
    )
  end

  def initialize(x, y, width, height)
    @x, @y, @width, @height = x, y, width, height
  end
end
