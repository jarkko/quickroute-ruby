class Person
  def initialize(data)
    length = BinData::Uint16le.read(data)
    LOGGER.debug "person length is #{length}"
    @name = BinData::String.new(:length => length).read(data)
    LOGGER.debug "person name is #{@name}"
    length = BinData::Uint16le.read(data)
    LOGGER.debug "club length is #{length}"
    @club = BinData::String.new(:length => length).read(data)

    @id = BinData::Uint32be.read(data)
    LOGGER.debug "id is #{@id}"
  end
end
