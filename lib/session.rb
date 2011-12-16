class Session
  include BinData
  include TagDataExtractor

  def initialize(data, tag_data_length)
    @laps = []
    @handles = []
    puts "Reading new session"
    start_pos = data.pos
    while data.pos < (start_pos + tag_data_length)
      tag, data_length = extract_tag_data(data)

      puts "tag is #{tag}, #{data_length} bytes"
      case tag
      when TAGS[:route]
        puts "reading route"
        @route = Route.new(data)
      when TAGS[:handles]
        puts "reading handles"
        handle_count = Uint32le.read(data)
        puts "reading #{handle_count} handles"
        handle_count.times do |i|
          @handles << Handle.new(data)
        end
      when TAGS[:projection_origin]
        puts "reading project origin"
        @projection_origin = LongLat.from_data(data)
      when TAGS[:laps]
        puts "reading laps"
        lap_count = Uint32le.read(data)
        puts "reading #{lap_count} laps"
        lap_count.times do
          @laps << Lap.new(data)
        end
      when TAGS[:session_info]
        puts "reading session info"
        @session_info = SessionInfo.new(data)
      end
    end
  end
end
