class MapController < ApplicationController
  def hunting_plot
		@hunting_plot = HuntingPlot.find(params[:id])
  end
end
