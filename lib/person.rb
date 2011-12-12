class Person
  def initialize(tag_data, subpos)
    length = Uint16be.read(tag_data[subpos,2])
    subpos += 2

    @name = BinData::String.read(tag_data[subpos, length])
    subpos += length

    length = Uint16be.read(tag_data[subpos,2])
    @club = BinData::String.read(tag_data[subpos, length])
    subpos += length

    @id = Uint32be.read(tag_data[subpos, 4])
    subpos += 4
  end
end
