class GridcellsController < ApplicationController

  def data
    @gridcell = GridCell.find_by_point(params[:latlng])
    #@crop = (Crop.find_by_name(params[:crop]) || @gricdell.crops.first)
    @climate_reports = @gridcell.climate_reports.all(:order=>"month ASC")
    render(:json=>{
      :gcid=>@gridcell.fid, 
      :climate=>{
        :temperature=>@climate_reports.map{|c| c.to_json('temperature')},
        :precipitation=>@climate_reports.map{|c| c.to_json('precipitation')}
      },
      :plantings => @gridcell.plantings.by_crop(params[:crop] || @gridcell.crops.first).map{|p| p.to_json}
    }) and return
  end

end
