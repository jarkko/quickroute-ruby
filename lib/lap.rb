class Lap
  def initialize(tag_data, subpos)
    @time = read_date_time(tag_data[subpos, 8])
    subpos += 8
    @type = Uint8be.read(tag_data[subpos, 1])
    subpos += 1
  end
end
