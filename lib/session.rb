class Session
  include BinData
  include TagDataExtractor
  attr_reader :laps, :handles, :route,
              :projection_origin, :session_info

  def initialize(data, tag_data_length)
    @laps = []
    @handles = []
    LOGGER.debug "Reading new session"
    start_pos = data.pos
    while data.pos < (start_pos + tag_data_length)
      tag, data_length = extract_tag_data(data)

      LOGGER.debug "tag is #{tag}, #{data_length} bytes"
      case tag
      when TAGS[:route]
        LOGGER.debug "reading route"
        @route = Route.new(data)
      when TAGS[:handles]
        LOGGER.debug "reading handles"
        handle_count = Uint32le.read(data)
        LOGGER.debug "reading #{handle_count} handles"
        handle_count.times do |i|
          @handles << Handle.new(data)
        end
      when TAGS[:projection_origin]
        LOGGER.debug "reading project origin"
        @projection_origin = LongLat.from_data(data)
      when TAGS[:laps]
        LOGGER.debug "reading laps"
        lap_count = Uint32le.read(data)
        LOGGER.debug "reading #{lap_count} laps"
        lap_count.times do
          @laps << Lap.new(data)
        end
      when TAGS[:session_info]
        LOGGER.debug "reading session info"
        @session_info = SessionInfo.new(data)
      end
    end
  end
end
