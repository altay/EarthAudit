class GridCell < ActiveRecord::Base
  SRID = 4269

  # find the grid cell that contains the given point.
  # latlng should be an array like [lat,lng] or a string "lat,lng"
  # returns null if not found
  def self.find_by_point(latlng)
    latlng = latlng.split(',') if latlng.class==String
    return self.first(:conditions => ["the_geom && ?", Point.from_coordinates(latlng.reverse, SRID)])
  end

end
