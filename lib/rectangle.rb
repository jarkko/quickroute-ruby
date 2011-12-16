class Rectangle
  attr_reader :x, :y, :width, :height

  def self.from_tag_data(data)
    new(
      BinData::Uint16le::read(data),
      BinData::Uint16le::read(data),
      BinData::Uint16le::read(data),
      BinData::Uint16le::read(data)
    )
  end

  def initialize(x, y, width, height)
    @x, @y, @width, @height = x, y, width, height
  end
end
