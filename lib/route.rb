class Route
  attr_reader :attributes, :extra_waypoints_attributes_length

  def initialize(tag_data)
    @segments = []

    subpos = 0
    @attributes = BinData::Uint16be.read(tag_data[subpos, 2])
    subpos += 2
    @extra_waypoints_attributes_length = BinData::Uint16be.read(tag_data[subpos, 2])
    subpos += 2
    segment_count = BinData::Uint32be.read(tag_data[subpos, 4])
    subpos += 4

    segment_count.times do |i|
      segment = RouteSegment.new(self, tag_data, subpos)

      segments << segment
    end
  end

  def has_attribute?(attribute)
    0 != (attributes & WAYPOINT_ATTRIBUTES[attribute])
  end
end
