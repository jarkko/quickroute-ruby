class Session
  include TagDataExtractor

  def initialize(data)
    @laps = []
    puts "Reading new session"
    while pos < data.length
      tag = extract_tag_data(data)

      case tag
      when TAGS[:route]
        @route = Route.new(data)
      when TAGS[:handles]
        handle_count = Uint32be.read(data)
        handle_count.each do |i|
          @handles << Handle.new(data)
        end
      when TAGS[:projection_origin]
        @projection_origin = LongLat.from_data(data)
      when TAGS[:laps]
        lap_count = Uint32be.read(data)

        lap_count.times do
          @laps << Lap.new(data)
        end
      when TAGS[:session_info]
        @session_info = SessionInfo.new(data)
      end
    end
  end
end
