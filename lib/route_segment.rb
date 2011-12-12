class RouteSegment
  attr_accessor :route, :last_time

  def initialize(route, tag_data, subpos)
    @route = route

    waypoints = []
    waypoint_count = BinData::Uint32be.read(tag_data[subpos, 4])
    subpos += 4

    waypoint_count.times do |j|
      waypoint = Waypoint.new(self, tag_data, subpos)
      waypoints << waypoint
      @last_time = waypoint.time
    end
  end
end
