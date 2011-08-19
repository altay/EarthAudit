class GridcellsController < ApplicationController

  def data
    @gridcell = GridCell.find_by_point(params[:latlng])
    logger.debug("FID: #{@gridcell.fid}")
    #@crop = (Crop.find_by_name(params[:crop]) || @gricdell.crops.first)
    @climate_reports = @gridcell.climate_reports.all(:order=>"month ASC")
    render(:json=>{
      :gcid=>@gridcell.fid, 
      :climate=>{
        :temperature=>@climate_reports.map{|c| c.to_json('temperature')}+[@climate_reports.first].map{|c| c.to_json('temperature',2011)},
        :precipitation=>@climate_reports.map{|c| c.to_json('precipitation')}+[@climate_reports.first].map{|c| c.to_json('precipitation',2011)}
      },
      :plantings => @gridcell.plantings.by_crop(params[:crop] || @gridcell.crops.first).map{|p| p.to_json},
      :crops => @gridcell.crops.map(&:name)
    }) and return
  end

end
