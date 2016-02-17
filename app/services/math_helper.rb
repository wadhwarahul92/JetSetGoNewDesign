class MathHelper

  EARTH_CURVATURE_CONSTANT = 3961

  class <<self

    def distance_between_lat_long(lat1, lon1, lat2, lon2)

      dlon = (Math::PI/180) * (lon2 - lon1)

      dlat = (Math::PI/180) * (lat2 - lat1)

      a = Math.sin(dlat/2) * Math.sin(dlat/2) + Math.cos( (Math::PI/180) * lat1 ) * Math.cos( (Math::PI/180) * lat2 ) * Math.sin(dlon/2) * Math.sin(dlon/2)

      c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a) )

      c * EARTH_CURVATURE_CONSTANT

    end

    def to_nm(miles)
      miles * 0.868976
    end

  end

end