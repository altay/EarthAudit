class Planting < ActiveRecord::Base
  belongs_to  :grid_cell
  belongs_to  :crop

  def to_json
    return {:crop=>self.crop.name, 
            :planting=>{:start=>format_timestamp(self.planting_start), :end=>format_timestamp(self.planting_end)}, 
            :harvest=>{:start=>format_timestamp(self.harvest_start), :end=>format_timestamp(self.harvest_end)}}
  end

  protected
  def format_timestamp(datetime)
    return nil if datetime.nil?
    return 1000*(datetime.to_f.to_i) #format("%s-%s-%s", datetime.year, datetime.month-1, datetime.day)
  end

end
