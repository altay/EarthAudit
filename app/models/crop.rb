class Crop < ActiveRecord::Base
  has_many  :plantings
  has_many  :grid_cells, :through => :plantings
end
