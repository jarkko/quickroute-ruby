class Route
  WAYPOINT_ATTRIBUTES = {
    :position => 1,
    :time => 2,
    :heart_rate => 4,
    :altitude => 8
  }

  attr_reader :attributes, :extra_waypoints_attributes_length,
    :segments, :distance, :elapsed_time

  def self.from_data(data)
    new.read_data(data)
  end

  def initialize
    LOGGER.debug "initializing new route"
    @segments = []
    @distance = 0
    @elapsed_time = 0
  end

  def read_data(data)
    @attributes = BinData::Uint16le.read(data)
    @extra_waypoints_attributes_length = BinData::Uint16be.read(data)
    read_segments_from(data)
    self
  end

  def has_attribute?(attribute)
    0 != (attributes & WAYPOINT_ATTRIBUTES[attribute])
  end

  def calculate_parameters
    segments.each{|s| s.calculate_waypoints}
  end

  def parameterized_location_from_time(time)
    return unless segment = segment_for_time(time)
    segment.parameterized_location_from_time(time)
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

    t = location.value - value

    waypoints.size < 2 ?
      [waypoints[0], waypoints[0], 0] :
      [waypoints[value], waypoints[value + 1], t]
  end

  def add_distance(dist)
    @distance += dist
  end

  def add_elapsed_time(time)
    @elapsed_time += time
  end

  private

  def segment_for_time(time)
    segments.find{|s| s.has_time?(time) }
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
