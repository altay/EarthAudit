class MainController < ApplicationController

  def test
  end

  def kmltest2
    respond_to do |format|
      format.xml
    end
  end

end
