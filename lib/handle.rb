require 'matrix'

class Handle
  attr_reader :transformation_matrix,
              :parameterized_location,
              :pixel_location,
              :type

  include BinData
  def initialize(data)
    @transformation_matrix = Matrix.build(3,3) do
      DoubleLe.read(data)
    end
    LOGGER.debug "matrix is #{@transformation_matrix.inspect}"
    @parameterized_location = ParameterizedLocation.new(
      BinData::Uint32le.read(data),
      DoubleLe.read(data)
    )
    LOGGER.debug "parameterized location is #{@parameterized_location.inspect}"

    # pixel location
    @pixel_location = Point.new(
      DoubleLe.read(data),
      DoubleLe.read(data)
    )
    LOGGER.debug "pixel_location is #{@pixel_location.inspect}"

    @type = BinData::Int16le.read(data)
    LOGGER.debug "handle type is #{@type}"
  end
end
