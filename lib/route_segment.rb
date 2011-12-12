class RouteSegment
  def initialize(route, tag_data, subpos)
    self.route = route

    waypoints = []
    waypoint_count = Uint32be.read(tag_data[subpos, 4])
    subpos += 4

    waypoint_count.times do |j|
      waypoint = Waypoint.new

      if route.has_attribute?(:position))
        waypoint.position = read_long_lat(tag_data[subpos, 8])
        subpos += 8
      end

      if route.has_attribute?(:time)
        time_type = Uint8be.read(tag_data[subpos, 1])
        subpos += 1
        if time_type == 0
          time = read_date_time(tag_data[subpos, 8])
          subpos += 8
        else
          time = last_time + Uint16.read(tag_data[subpos, 2]) / 1000
          subpos += 2
        end

        waypoint.time = time
      end

      if route.has_attribute?(:heart_rate)
        waypoint.heartrate = Uint8be.read(tag_data[subpos, 1])
        subpos += 1
      end]

      if route.has_attribute?(:altitude)
        waypoint.altitude = Uint16be.read(tag_data[subpos, 2])
        subpos += 2
      end

      subpos += route.extra_waypoints_attributes_length
      waypoints << waypoint
      last_time = time
    end
  end
end
