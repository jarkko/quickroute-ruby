class ParameterizedLocation
  attr_reader :segment_index, :value

  def initialize(segment_index, value)
    @segment_index = segment_index
    @value = value
  end
end
