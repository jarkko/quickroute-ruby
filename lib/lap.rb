class Lap
  def initialize(data)
    @time = read_date_time(data)
    @type = Uint8be.read(data)
  end
end
