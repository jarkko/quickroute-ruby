class Waypoint
  include BinData
  include DateTimeParser

  attr_reader :segment, :time, :position, :heart_rate, :altitude

  def initialize(segment, data)
    @segment = segment

    if route.has_attribute?(:position)
      LOGGER.debug "route did have the position attribute"
      @position = LongLat.from_data(data)
      LOGGER.debug "waypoint position: #{@position.inspect}"
    end

    if route.has_attribute?(:time)
      LOGGER.debug "route did have the time attribute"
      time_type = BinData::Uint8le.read(data)
      if time_type == 0
        time = read_date_time(data)
      else
        time = last_time + BinData::Uint16le.read(data) / 1000
      end
      LOGGER.debug "time was #{Time.at(time)}"
      @time = time
    end

    if route.has_attribute?(:heart_rate)
      LOGGER.debug "route did have the heart rate attribute"
      @heartrate = Uint8be.read(data)
    end

    if route.has_attribute?(:altitude)
      LOGGER.debug "route did have the altitude attribute"
      @altitude = Uint16le.read(data)
      LOGGER.debug "altitude was #{@altitude}"
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
