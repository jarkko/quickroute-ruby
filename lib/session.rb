class Session
  include BinData

  attr_reader :laps, :handles, :route,
    :projection_origin, :session_info,
    :straight_line_distance

  def self.read_sessions(data)
    sessions = []
    session_count = BinData::Uint32le.read(data)
    LOGGER.debug "reading #{session_count} sessions"

    session_count.times do |i|
      tag, tag_data_length = TagDataExtractor.extract_tag_data(data)

      LOGGER.debug "in session #{i}, tag is #{tag} and is #{tag_data_length} bytes long"

      if TAGS[tag] == :session
        sessions << read_session(data, tag_data_length)
      end
    end
    sessions
  end

  def self.read_session(data, tag_data_length)
    new(data, tag_data_length)
  end

  def initialize(data, tag_data_length)
    @laps = []
    @handles = []
    @straight_line_distance = 0
    LOGGER.debug "Reading new session"
    parse_data(data, tag_data_length)
  end

  def calculate_laps
    last_distance = 0

    @laps.each do |lap|
      pl = route.parameterized_location_from_time(lap.time)
      lap.position = route.position_from_parameterized_location(pl)

      distance = route.distance_from_parameterized_location(pl)
      if lap.is_of_type?(LAP_TYPE_LAP, LAP_TYPE_STOP)
        lap.distance = distance - last_distance

        if last_lap
          lap.straight_line_distance = lap.position.distance_to(last_lap.position)
        else
          lap.straight_line_distance = 0
        end
        @straight_line_distance += lap.straight_line_distance
      end
      last_distance = distance
      last_lap = lap
    end
  end

  private

  def parse_data(data, tag_data_length)
    start_pos = data.pos
    while data.pos < (start_pos + tag_data_length)
      tag, data_length = TagDataExtractor.extract_tag_data(data)

      LOGGER.debug "tag is #{tag}, #{data_length} bytes"

      send("set_#{TAGS[tag]}", data)
    end
  end

  def set_route(data)
    LOGGER.debug "reading route"
    @route = Route.new(data)
  end

  def set_handles(data)
    LOGGER.debug "reading handles"
    handle_count = Uint32le.read(data)
    LOGGER.debug "reading #{handle_count} handles"
    handle_count.times do |i|
      @handles << Handle.new(data)
    end
  end

  def set_projection_origin(data)
    LOGGER.debug "reading project origin"
    @projection_origin = LongLat.from_data(data)
  end

  def set_laps(data)
    LOGGER.debug "reading laps"
    lap_count = Uint32le.read(data)
    LOGGER.debug "reading #{lap_count} laps"
    lap_count.times do
      @laps << Lap.new(data)
    end
  end

  def set_session_info(data)
    LOGGER.debug "reading session info"
    @session_info = SessionInfo.new(data)
  end
end
