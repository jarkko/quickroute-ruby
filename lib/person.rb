class Person
  def initialize(data)
    length = BinData::Uint16le.read(data)
    puts "person length is #{length}"
    @name = BinData::String.new(:length => length).read(data)
    puts "person name is #{@name}"
    length = BinData::Uint16le.read(data)
    puts "club length is #{length}"
    @club = BinData::String.new(:length => length).read(data)

    @id = BinData::Uint32be.read(data)
    puts "id is #{@id}"
  end
end
