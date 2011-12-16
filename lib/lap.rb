class Lap
  attr_reader :time, :type

  include DateTimeParser
  def initialize(data)
    @time = read_date_time(data)
    @type = BinData::Uint8be.read(data)
  end
end
