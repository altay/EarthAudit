class GridcellsController < ApplicationController

  def data
    @gridcell = GridCell.find_by_point(params[:latlng])
    @climate_reports = @gridcell.climate_reports.all(:order=>"month ASC")
    render(:json=>{:gcid=>@gridcell.fid, :climate=>{
      :temperature=>@climate_reports.map{|c| c.to_json('temperature')},
      :precipitation=>@climate_reports.map{|c| c.to_json('precipitation')}
    }}) and return
  end

end
