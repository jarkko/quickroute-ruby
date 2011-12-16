require 'matrix'

class Handle
  include BinData
  def initialize(data)
    @transformation_matrix = Matrix.build(3,3) do
      DoubleLe.read(data)
    end
    puts "matrix is #{@transformation_matrix.inspect}"
    @parameterized_location = ParameterizedLocation.new(
      BinData::Uint32le.read(data),
      DoubleLe.read(data)
    )
    puts "parameterized location is #{@parameterized_location.inspect}"

    # pixel location
    @pixel_location = Point.new(
      DoubleLe.read(data),
      DoubleLe.read(data)
    )
    puts "pixel_location is #{@pixel_location.inspect}"

    @type = BinData::Int16le.read(data)
    puts "handle type is #{@type}"
  end
end
