class LongLat
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
    sin_phi0 = sin_phi
    cos_phi0 = cos_phi
    sin_theta0 = sin_theta
    cos_theta0 = cos_theta

    sin_phi1 = other.sin_phi
    cos_phi1 = other.cos_phi
    sin_theta1 = other.sin_theta
    cos_theta1 = other.cos_theta

    p0 = Matrix[[rho * sin_phi0 * cos_theta0,
                 rho * sin_phi0 * sin_theta0
                 rho * cos_phi0]]

    p1 = Matrix[[rho * sin_phi1 * cos_theta1,
                 rho * sin_phi1 * sin_theta1
                 rho * cos_phi1]]

    distance_point_to_point(p0, p1)
  end

  def sin_phi
    Math::sin(0.5 * Math::PI + latitude / 180 * Math::PI))
  end

  def cos_phi
    Math::cos(0.5 * Math::PI + latitude / 180 * Math::PI))
  end

  def sin_theta
    Math::sin(longitude / 180 * Math::PI)
  end

  def cos_theta
    Math::cos(longitude / 180 * Math::PI)
  end

  private

  def distance_point_to_point(p0, p1)
   
  end
end
