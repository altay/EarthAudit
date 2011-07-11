class GridCell < ActiveRecord::Base
  has_many :climate_reports
  has_many :plantings do
    def by_crop(crop)
      crop = Crop.find_by_name(crop) if crop.class==String
      return [] if crop.nil?
      return self.all(:conditions=>{:crop_id=>crop.id})
    end
  end
  has_many :crops, :through => :plantings
  SRID = 4269

  # find the grid cell that contains the given point.
  # latlng should be an array like [lat,lng] or a string "lat,lng"
  # returns nil if not found
  def self.find_by_point(latlng)
    return nil if latlng.nil?
    latlng = latlng.split(',') if latlng.class==String
    return self.first(:conditions => ["the_geom && ?", Point.from_coordinates(latlng.reverse, SRID)])
  end

end
