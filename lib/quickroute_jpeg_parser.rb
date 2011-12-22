TAGS ={
  1  => :version,
  2  => :map_corner_positions,
  3  => :image_corner_positions,
  4  => :map_location_and_size_in_pixels,
  5  => :sessions,
  6  => :session,
  7  => :route,
  8  => :handles,
  9  => :projection_origin,
  10 => :laps,
  11 => :session_info
}

class QuickrouteJpegParser
  include BinData
  attr_reader :sessions, :map_corner_positions, :image_corner_positions,
              :map_location_and_size_in_pixels, :version

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

  def calculate_data
    sessions.each{|s| s.calculate}
  end

  def fetch_data_from(filename)
    JpegReader.fetch_data_from(filename)
  end

  def process_data(data)
    LOGGER.debug "Starting to process data"
    data = StringIO.new(data)

    while !data.eof?
      tag = TagDataExtractor.read(data)
      LOGGER.debug "tag: #{tag.inspect}, tag length: #{tag.data_length.inspect}"
      read_tag(tag, data)
    end
  end

  def read_tag(tag, data)
    send("set_#{TAGS[tag.tag]}", data)
  end

  def set_version(data)
    LOGGER.debug "Reading version number"
    @version = version_number(data)
    LOGGER.debug "version is: #{@version}"
  end

  def set_map_corner_positions(data)
    LOGGER.debug "Reading map corner positions:"
    @map_corner_positions = corner_positions(data)
    LOGGER.debug "#{@map_corner_positions.inspect}"
  end

  def set_image_corner_positions(data)
    LOGGER.debug "Reading image corner number"
    @image_corner_positions = corner_positions(data)
    LOGGER.debug "#{@image_corner_positions.inspect}"
  end

  def set_map_location_and_size_in_pixels(data)
    LOGGER.debug "Reading map location and size"
    @map_location_and_size_in_pixels = Rectangle.read(data)
    LOGGER.debug "#{@map_location_and_size_in_pixels.inspect}"
  end

  def set_sessions(data)
    @sessions = Session.read_sessions(data)
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
