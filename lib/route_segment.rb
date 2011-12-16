class RouteSegment
  attr_accessor :route, :last_time

  def initialize(route, data)
    puts "Initializing route segment"
    @route = route

    waypoints = []
    waypoint_count = BinData::Uint32le.read(data)
    puts "reading #{waypoint_count} waypoints"
    waypoint_count.times do |j|
      waypoint = Waypoint.new(self, data)
      waypoints << waypoint
      @last_time = waypoint.time
    end
  end
end
