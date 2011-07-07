class GridcellsController < ApplicationController

  def data
    @gridcell = GridCell.find_by_point(params[:latlng])
    @climate_reports = @gridcell.climate_reports.all(:order=>"month ASC")
    render(:json=>@climate_reports.map(&:to_json)) and return
  end

end
