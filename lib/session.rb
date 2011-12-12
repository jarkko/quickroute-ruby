class Session
  include TagDataExtractor

  def initialize(data)
    @laps = []
    puts "Reading new session"
    pos = 0
    while pos < data.length
      tag, tag_data, tag_data_length, pos = extract_tag_data(data, pos)

      case tag
      when TAGS[:route]
        @route = Route.new(tag_data)
      when TAGS[:handles]
        handle_count = Uint32be.read(tag_data[0, 4])
        subpos = 4
        handle_count.each do |i|
          handle = Handle.new(tag_data, subpos)
          @handles << handle
        end
      when TAGS[:projection_origin]
        @projection_origin = read_long_lat(tag_data[0, 8])
      when TAGS[:laps]
        lap_count = Uint32be.read(tag_data[0, 4])
        subpos = 4

        lap_count.times do
          @laps << Lap.new(tag_data, subpos)
        end
      when TAGS[:session_info]
        @session_info = SessionInfo.new(tag_data)
      end
    end
  end
end
