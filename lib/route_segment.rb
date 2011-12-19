class RouteSegment
  attr_accessor :route, :last_time
  attr_reader :waypoints

  def initialize(route, data)
    LOGGER.debug "Initializing route segment"
    @route = route

    @waypoints = []
    waypoint_count = BinData::Uint32le.read(data)
    LOGGER.debug "reading #{waypoint_count} waypoints"
    waypoint_count.times do |j|
      waypoint = Waypoint.new(self, data)
      @waypoints << waypoint
      @last_time = waypoint.time
    end
  end

  def index
    @route.segments.index(self)
  end
end
