class Person
  def initialize(data)
    length = Uint16be.read(data)
    @name = BinData::String.read(data, :length => length)

    length = Uint16be.read(data)
    @club = BinData::String.read(data, :length => length)

    @id = Uint32be.read(data)
  end
end
