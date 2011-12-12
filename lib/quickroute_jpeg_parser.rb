TAGS = {
  :version => 1,
  :map_corner_positions => 2,
  :image_corner_positions => 3,
  :map_location_and_size_in_pixels => 4,
  :sessions => 5,
  :session => 6,
  :route => 7,
  :handles => 8,
  :projection_origin => 9,
  :laps => 10,
  :session_info => 11
}

WAYPOINT_ATTRIBUTES = {
  :position => 1,
  :time => 2,
  :heart_rate => 4,
  :altitude => 8
}

class String
  def to_b
    BinData::String.new(self).to_binary_s
  end
end

class QuickrouteJpegParser
  include TagDataExtractor
  include BinData

  def initialize(filename, calculate)
    @map_corner_positions = {}
    @image_corner_positions = {}

    start_time = Time.now

    data = fetch_data_from(filename)

    if !data.empty?
      process_data(data)
      calculate_data if calculate
    end

    end_time = Time.now
    @execution_time = end_time - start_time
  end

  private

  def fetch_data_from(filename)
    data = ""

    File.open(filename, "r") do |f|
      if f.read(2) == "\xff\xd8".to_b
        while !f.eof?
          break if f.read(1) != "\xff".to_b

          if f.read(1) == "\xe0".to_b # APP0
            quickroute_segment = false
            length = BinData::Uint16be.read(f)

            if length >= 12
              if f.read(10) == "QuickRoute".to_b
                data << f.read(length - 12)
                quickroute_segment = true
              else
                f.seek(length - 12, ::IO::SEEK_CUR)
              end
            else
              f.seek(length - 2, ::IO::SEEK_CUR)
            end

            break if !quickroute_segment && !data.empty?
          else
            break
          end
        end
      end
    end

    data
  end

  def process_data(data)
    puts "Starting to process data"
    data = StringIO.new(data)

    while !data.eof?
      tag = extract_tag_data(data)
      puts "tag: #{tag.inspect}"
      read_tag(tag, data)
    end
  end

  def read_tag(tag, data)
    case tag
    when TAGS[:version]
      puts "Reading version number"
      @version = version_number(data)
    when TAGS[:map_corner_positions]
      puts "Reading map corner positions"
      @map_corner_positions = corner_positions(data)
    when TAGS[:image_corner_positions]
      puts "Reading image corner number"
      @image_corner_positions = corner_positions(data)
    when TAGS[:map_location_and_size_in_pixels]
      puts "Reading map location and size"
      @map_location_and_size_in_pixels = Rectangle.from_tag_data(data)
    when TAGS[:sessions]
      @sessions = read_sessions(data)
    end
  end

  def read_sessions(data)
    sessions = []
    session_count = BinData::Uint32be.read(data)

    session_count.times do |i|
      tag = extract_tag_data(data)

      if tag == TAGS[:session]
        sessions << read_session(data)
      end
    end
  end

  def read_session(data)
    Session.new(data)
  end

  def corner_positions(data)
    {:sw => read_long_lat(data),
     :nw => read_long_lat(data),
     :ne => read_long_lat(data),
     :se => read_long_lat(data)}
  end

  def version_number(data)
    [BinData::Uint8be.read(data),
     BinData::Uint8be.read(data),
     BinData::Uint8be.read(data),
     BinData::Uint8be.read(data)].join(".")
  end

  def read_long_lat(data)
    LongLat.from_data(data)
  end

end
