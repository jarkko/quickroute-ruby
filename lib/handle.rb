class Handle
  def initialize(tag_data, subpos)
    @transformation_matrix = Matrix.new(3,3)
    3.times do |j|
      3.times do |k|
        value = DoubleBe.read(tag_data[subpos, 8])
        @transformation_matrix.set_element(j, k, value)
        subpos += 8
      end
    end

    @parameterized_location = ParameterizedLocation.new
    @parameterized_location.segment_index = Uint32be.read(tag_data[subpos, 4])
    subpos += 4
    @parameterized_location.value = DoubleBe.read(tag_data[subpos, 8])
    subpos += 8

    # pixel location
    @pixel_location = Point.new(
      DoubleBe.read(tag_data[subpos, 8]),
      DoubleBe.read(tag_data[(subpos += 8), 8])
    )
    subpos += 8

    @type = Int16be.read(tag_data[subpos, 2])
    subpos += 2
  end
end
