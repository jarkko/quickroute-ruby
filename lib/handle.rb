class Handle
  def initialize(data)
    @transformation_matrix = Matrix.new(3,3)
    3.times do |j|
      3.times do |k|
        value = DoubleBe.read(data)
        @transformation_matrix.set_element(j, k, value)
      end
    end

    @parameterized_location = ParameterizedLocation.new
    @parameterized_location.segment_index = Uint32be.read(data)
    @parameterized_location.value = DoubleBe.read(data)

    # pixel location
    @pixel_location = Point.new(
      DoubleBe.read(data),
      DoubleBe.read(data)
    )

    @type = Int16be.read(data)
  end
end
