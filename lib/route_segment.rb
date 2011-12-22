class RouteSegment
  attr_accessor :route, :last_time
  attr_reader :waypoints

  def initialize(route, data = nil)
    LOGGER.debug "Initializing route segment"
    @route = route

    @waypoints = []
    read_waypoints(data) if data
  end

  def read_waypoints(data)
    waypoint_count = BinData::Uint32le.read(data)
    LOGGER.debug "reading #{waypoint_count} waypoints"
    waypoint_count.times do |j|
      waypoint = Waypoint.new(self, data)
      add_waypoint(waypoint)
      @last_time = waypoint.time
    end
  end

  def add_waypoint(*points)
    points.each do |point|
      waypoints << point
    end
  end

  def calculate_waypoints
    segment_distance = 0
    waypoints.each_with_index do |wp, idx|
      segment_distance += (idx == 0 ? 0 : wp.distance_to(waypoints[idx - 1]))
      wp.distance = route.distance + segment_distance

      wp.elapsed_time = route.elapsed_time + wp.time - waypoints.first.time
    end
    @route.add_distance(segment_distance)
    @route.add_elapsed_time(waypoints.last.time - waypoints.first.time)
  end

  def index
    @route.segments.index(self)
  end
end
