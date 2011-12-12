class SessionInfo
  def initialize(tag_data)
    subpos = 0
    @person = Person.new(tag_data, subpos)

    length = Uint16be.read(tag_data[subpos,2])
    subpos += 2

    @description = BinData::String.read(tag_data[subpos, length])
    subpos += length
  end
end
