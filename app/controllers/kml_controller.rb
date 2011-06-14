class KmlController < ApplicationController

  def gridcells
    @offset = params[:offset]
    if params[:gcid]
      @gridcells = [GridCell.find(params[:gcid])]
      @highlight = true
    elsif params[:latlng]
      @gridcells = [GridCell.find_by_point(params[:latlng])]
      @highlight = true
    end
    if @gridcells.nil? || @gridcells.empty?
      @gridcells = GridCell.all(:limit=>2500, :offset=>@offset)
    end
    if params[:format] = "kmz"
      filename = "gridcells.kml"
      zipfilename = "gridcells.kmz"
      filepath = "#{Rails.root}/public/kmz_cache/gridcells.kmz?offset=#{@offset}"
      if !@highlight && File.exists?(filepath)
        data = File.read(filepath)
      else
        data = zip(render_to_string(:action=>"kml/gridcells.xml", :layout => false), 
                   {:filename=>filename, :do_not_delete=>!@highlight, :zipfilename=>(filepath unless @highlight)})
      end
      send_data(data, :filename => zipfilename, :type => 'application/vnd.google-earth.kmz')
    else
      respond_to do |format|
        format.xml
      end
    end
  end

end
