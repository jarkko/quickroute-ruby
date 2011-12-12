# encoding: US-ASCII
#
#

class String
  def to_b
    BinData::String.new(self).to_binary_s
  end
end

class QuickrouteJpegParser
  include BinData

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
                f.seek(length - 12, IO::SEEK_CUR)
              end
            else
              f.seek(length - 2, IO::SEEK_CUR)
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
    length = data.length

    pos = 0

    while pos < length
      tag, tag_data, tag_data_length = extract_tag_data(data, pos)

      read_tag(tag, tag_data)
    end
  end

  def read_tag(tag, tag_data)
    case tag
    when TAGS[:version]
      @version = version_number(tag_data)
    when TAGS[:map_corner_positions]
      @map_corner_positions = corner_positions(tag_data)
    when TAGS[:image_corner_positions]
      @image_corner_positions = corner_positions(tag_data)
    when TAGS[:map_location_and_size_in_pixels]
      @map_location_and_size_in_pixels = Rectangle.from_tag_data(tag_data)
    when TAGS[:sessions]
      @sessions = read_sessions(tag_data)
    end
  end

  def read_sessions(data)
    sessions = []
    session_count = BinData::Uint32be.read(data[0,4])
    pos = 4
    data_length = data.length

    session_count.times do |i|
      tag, tag_data, tag_data_length = extract_tag_data(data, pos)

      if tag == TAGS[:session]
        sessions << read_session(tag_data)
      end
    end
  end

  def read_session(data)
    session = Session.new

    pos = 0
    while pos < data.length
      tag, tag_data, tag_data_length = extract_tag_data(data, pos)

      case tag
      when TAGS[:route]
        session.route = Route.new(tag_data)
      end
    end
  end

  def extract_tag_data(data, pos)
    tag = BinData::Uint8be.read(data[pos,1])
    pos += 1
    tag_data_length = BinData::Uint32le.read(data[pos, 4])
    pos += 4
    tag_data = data[pos, tag_data_length]
    pos += tag_data_length)

    tag, tag_data, tag_data_length
  end

  def corner_positions(tag_data)
    {:sw => read_long_lat(tag_data[0,8]),
     :nw => read_long_lat(tag_data[8,8]),
     :ne => read_long_lat(tag_data[16,8]),
     :se => read_long_lat(tag_data[24,8])}
  end

  def version_number(tag_data)
    [BinData::Uint8be.read(tag_data[0,1]),
     BinData::Uint8be.read(tag_data[1,1]),
     BinData::Uint8be.read(tag_data[2,1]),
     BinData::Uint8be.read(tag_data[3,1])].join(".")
  end

  def read_long_lat(data)
    LongLat.new(
      BinData::Int32be.read(data[0,4]) / 3600000,
      BinData::Int32be.read(data[4,4]) / 3600000
    )
  end

end
