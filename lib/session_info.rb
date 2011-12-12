class SessionInfo
  def initialize(data)
    @person = Person.new(data)

    length = Uint16be.read(data)

    @description = BinData::String.read(data, :length => length)
  end
end
