class HuntingAppController < ApplicationController

  before_action :set_hunting_plot

  layout 'hunting_app'

  def landing_page

  end

  def map

  end

  def activity

  end

  def conditions
  end

  def check_in
    location_coordinates = "POINT(#{params[:position][:lng]} #{params[:position][:lat]})"
    locationRecord = HuntingModeUserLocation.find_by(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id])
    if locationRecord.nil?
      HuntingModeUserLocation.create!(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id], location_coordinates: location_coordinates)
    else
      locationRecord.update_attribute(:location_coordinates, location_coordinates)
    end
  end

private
  def set_hunting_plot
    @hunting_plot = HuntingPlot.find(params[:hunting_plot_id])
  end

end
