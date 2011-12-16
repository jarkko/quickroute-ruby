class Route
  attr_reader :attributes, :extra_waypoints_attributes_length

  def initialize(data)
    puts "initializing new route"
    @segments = []

    @attributes = BinData::Uint16le.read(data)

    @extra_waypoints_attributes_length = BinData::Uint16be.read(data)
    segment_count = BinData::Uint32le.read(data)
    puts "reading #{segment_count} segments"
    segment_count.times do |i|
      segment = RouteSegment.new(self, data)

      @segments << segment
    end
  end

  def has_attribute?(attribute)
    0 != (attributes & WAYPOINT_ATTRIBUTES[attribute])
  end
end
