class Route
  attr_reader :attributes, :extra_waypoints_attributes_length

  def initialize(data)
    @segments = []

    @attributes = BinData::Uint16be.read(data)
    @extra_waypoints_attributes_length = BinData::Uint16be.read(data)
    segment_count = BinData::Uint32be.read(data)

    segment_count.times do |i|
      segment = RouteSegment.new(self, data)

      segments << segment
    end
  end

  def has_attribute?(attribute)
    0 != (attributes & WAYPOINT_ATTRIBUTES[attribute])
  end
end
