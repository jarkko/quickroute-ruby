class LongLat
  # earth radius in meters
  RHO = 6378200

  attr_accessor :longitude, :latitude

  def initialize(longitude, latitude)
    @longitude, @latitude = longitude, latitude
  end

  def self.from_data(data)
    new(
      BinData::Int32le.read(data) / 3600000.0,
      BinData::Int32le.read(data) / 3600000.0
    )
  end

  def distance_to(other)
    distance_point_to_point(point_matrix, other.point_matrix)
  end

  def point_matrix
    Matrix[[RHO * sin_phi * cos_theta],
           [RHO * sin_phi * sin_theta],
           [RHO * cos_phi]]
  end

  private

  def sin_phi
    Math::sin(0.5 * Math::PI + latitude / 180 * Math::PI)
  end

  def cos_phi
    Math::cos(0.5 * Math::PI + latitude / 180 * Math::PI)
  end

  def sin_theta
    Math::sin(longitude / 180 * Math::PI)
  end

  def cos_theta
    Math::cos(longitude / 180 * Math::PI)
  end

  def distance_point_to_point(p0, p1)
    sum = 0
    p0.each_with_index do |el, row, col|
      sum += ((p1[row, col] - el)**2)
    end
    Math.sqrt(sum)
  end
end
