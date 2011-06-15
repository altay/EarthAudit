class GridcellsController < ApplicationController

  def data
    @gridcell = GridCell.find_by_point(params[:latlng])
    render(:json=>@gridcell.to_json) and return
  end

end
