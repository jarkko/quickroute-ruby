class SessionInfo
  def initialize(data)
    @person = Person.new(data)

    length = BinData::Uint16le.read(data)
    puts "description length is #{length}"
    @description = BinData::String.new(:length => length).read(data)
  end
end
