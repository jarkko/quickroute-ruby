class RouteSegment
  attr_accessor :route, :last_time

  def initialize(route, data)
    @route = route

    waypoints = []
    waypoint_count = BinData::Uint32be.read(data)

    waypoint_count.times do |j|
      waypoint = Waypoint.new(self, data)
      waypoints << waypoint
      @last_time = waypoint.time
    end
  end
end
