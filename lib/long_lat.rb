class LongLat
  attr_accessor :longitude, :latitude

  def initialize(longitude, latitude)
    @longitude, @latitude = longitude, latitude
  end

  def self.from_data(data)
    new(
      BinData::Int32le.read(data) / 3600000.0,
      BinData::Int32le.read(data) / 3600000.0
    )
  end
end
