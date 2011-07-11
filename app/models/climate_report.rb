class ClimateReport < ActiveRecord::Base
  belongs_to :grid_cell
  #MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  # data_type is either 'temperature' or 'precipitation'
  def to_json(data_type)
    timestamp = 1000*DateTime.new(2010,self.month+1).to_f.to_i
    return [timestamp, self.send(data_type)]
  end
end
