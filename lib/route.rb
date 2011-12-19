class Route
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

  private

  def read_segments_from(data)
    segment_count = BinData::Uint32le.read(data)
    LOGGER.debug "reading #{segment_count} segments"
    segment_count.times do |i|
      segment = RouteSegment.new(self, data)

      @segments << segment
    end
  end
end
