class Route
  EPSILON = 0.001

  WAYPOINT_ATTRIBUTES = {
    :position => 1,
    :time => 2,
    :heart_rate => 4,
    :altitude => 8
  }

  attr_reader :attributes, :extra_waypoints_attributes_length,
    :segments

  def initialize(data)
    LOGGER.debug "initializing new route"
    @segments = []

    @attributes = BinData::Uint16le.read(data)

    @extra_waypoints_attributes_length = BinData::Uint16be.read(data)

    read_segments_from(data)
  end

  def has_attribute?(attribute)
    0 != (attributes & WAYPOINT_ATTRIBUTES[attribute])
  end

  def parameterized_location_from_time(time)
    return unless segment = segment_for_time(time)

    lower, upper = 0, segment.waypoints.size - 1

    # Binary search to find the closest waypoint
    while lower <= upper
      idx = lower + (upper - lower) / 2
      currtime = segment.waypoints[idx].time
      if (time - currtime).abs < EPSILON
        return ParameterizedLocation.new(segment.index, idx)
      end

      if time < currtime
        upper = idx - 1
      else
        lower = idx + 1
      end
    end

    t0 = segment.waypoints[upper].time
    t1 = segment.waypoints[lower].time
    if t1 == t0
      return ParameterizedLocation.new(segment.index, upper)
    end

    ParameterizedLocation.new(segment.index, upper + (time - t0) / (t1 - t0))
  end

  def position_from_parameterized_location(location)
    return unless location
    w0, w1, t = waypoints_and_parameter_from_parameterized_location(location)

    LongLat.new(
      w0.position.longitude + t * (w1.position.longitude - w0.position.longitude),
      w0.position.latitude + t * (w1.position.latitude - w0.position.latitude)
    )
  end

  def distance_from_parameterized_location(location)
    return unless location
    w0, w1, t = waypoints_and_parameter_from_parameterized_location(location)
    w0.distance + t * (w1.distance - w0.distance)
  end

  def waypoints_and_parameter_from_parameterized_location(location)
    return unless location && segment = segments[location.segment_index]

    waypoints = segment.waypoints

    value = location.value.to_i

    if value >= waypoints.size - 1
      value = waypoints.size - 2
    end

    if waypoints.size < 2
      return [waypoints[0], waypoints[0], 0]
    end

    t = location.value - value

    [waypoints[value], waypoints[value + 1], t]
  end

  private

  def segment_for_time(time)
    segment = segments.find do |s|
      ((s.waypoints.first.time - EPSILON)..(s.waypoints.last.time + EPSILON)).include?(time)
    end
  end

  def read_segments_from(data)
    segment_count = BinData::Uint32le.read(data)
    LOGGER.debug "reading #{segment_count} segments"
    segment_count.times do |i|
      segment = RouteSegment.new(self, data)

      @segments << segment
    end
  end
end
