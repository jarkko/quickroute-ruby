class LongLat
  attr_accessor :longitude, :latitude

  def initialize(longitude, latitude)
    @longitude, @latitude = longitude, latitude
  end

  def self.from_data(data)
    new(
      BinData::Int32be.read(data) / 3600000,
      BinData::Int32be.read(data) / 3600000
    )
  end
end
