class ClimateReport < ActiveRecord::Base
  belongs_to :grid_cell
  MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  def to_json
    return [MONTHS[self.month], self.precipitation, self.temperature]
    #return {'m'=>self.month, 'y'=>self.year, 't'=>self.temperature, 'p'=>self.precipitation} #.to_json
  end
end
