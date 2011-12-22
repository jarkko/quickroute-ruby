class Lap
  TYPES = {
    :start => 0,
    :lap   => 1,
    :stop  => 2
  }

  attr_reader :time, :type

  include DateTimeParser

  def initialize(data)
    @time = read_date_time(data)
    @type = BinData::Uint8be.read(data)
  end

  def is_of_type?(*types)
    types.any?{|t| type == TYPES[t]}
  end
end
