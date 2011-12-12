class Waypoint
  attr_reader :segment, :time

  def initialize(segment, tag_data)
    @segment = segment

    if route.has_attribute?(:position)
      @position = read_long_lat(tag_data)
    end

    if route.has_attribute?(:time)
      time_type = Uint8be.read(data)
      if time_type == 0
        time = read_date_time(data)
      else
        time = last_time + Uint16.read(data) / 1000
      end

      @time = time
    end

    if route.has_attribute?(:heart_rate)
      @heartrate = Uint8be.read(data)
    end

    if route.has_attribute?(:altitude)
      @altitude = Uint16be.read(data)
    end

    data.seek(route.extra_waypoints_attributes_length, ::IO::SEEK_CUR)
  end

  def last_time
    segment.last_time
  end

  def route
    segment.route
  end
end
