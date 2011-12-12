class Waypoint
  delegate :last_time, :route, :to => :segment
  attr_reader :segment

  def initialize(segment, tag_data, subpos)
    @segment = segment

    if route.has_attribute?(:position))
      @position = read_long_lat(tag_data[subpos, 8])
      subpos += 8
    end

    if route.has_attribute?(:time)
      time_type = Uint8be.read(tag_data[subpos, 1])
      subpos += 1
      if time_type == 0
        time = read_date_time(tag_data[subpos, 8])
        subpos += 8
      else
        time = last_time + Uint16.read(tag_data[subpos, 2]) / 1000
        subpos += 2
      end

      @time = time
    end

    if route.has_attribute?(:heart_rate)
      @heartrate = Uint8be.read(tag_data[subpos, 1])
      subpos += 1)
    end]

    if route.has_attribute?(:altitude)
      @altitude = Uint16be.read(tag_data[subpos, 2])
      subpos += 2
    end

    subpos += route.extra_waypoints_attributes_length
  end
end
