class HuntingAppController < ApplicationController

  before_action :ensure_signed_in
  before_action :set_hunting_plot

  layout 'hunting_app'

  def landing_page
    @last_checkin = HuntingModeUserLocation.find_by(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id])
    @hunting_location_schedules = HuntingLocationSchedule.current_schedules_for_plot(@hunting_plot)
  end

  def map
    @member_locations = HuntingModeUserLocation.where(hunting_plot_id: params[:hunting_plot_id]).where('updated_at > ?', 1.days.ago).preload(:user).preload(:hunting_location)
  end

  def activity
    @animal_activity_observations = AnimalActivityObservation.search(@hunting_plot.id, params).preload(:hunting_location).preload(:named_animal)

    @filters = Array.new

    unless params[:animal_category_id].blank?
      animal_category_ids = params[:animal_category_id]
      animal_category_names = animal_category_ids.collect { |category_id| ConfigData.animal_categories[category_id.to_i][:name] }
      @filters << { item_name: "Deer type(s)", item_values: animal_category_names }
    end

    unless params[:animal_activity_type_id].blank?
      animal_activity_type_ids = params[:animal_activity_type_id]
      animal_activity_names = animal_activity_type_ids.collect { |animal_activity_type_id| ConfigData.animal_activity_types[animal_activity_type_id.to_i][:name] }
      @filters << { item_name: "Behavior(s)", item_values: animal_activity_names }
    end

    unless params[:hunting_plot_named_animal_id].blank?
      named_animal_ids = params[:hunting_plot_named_animal_id]
      named_animals = named_animal_ids.collect { |named_animal_id| HuntingPlotNamedAnimal.find(named_animal_id.to_i).name }
      @filters << { item_name: "Named Animal(s)", item_values: named_animals }
    end

    unless (params[:after_date].blank? && params[:before_date].blank?)
      if params[:after_date].blank?
        date_range = "before #{params[:before_date]}"
      elsif params[:before_date].blank?
        date_range = "after #{params[:after_date]}"
      else
        date_range = "#{params[:after_date]} - #{params[:before_date]}"
      end
      @filters << { item_name: "Date Range", item_values: [ date_range ] }
    end

  end

  def conditions

  end

  def check_in
    is_at_plot = (params[:is_at_plot] == 'true')
    locationRecord = HuntingModeUserLocation.find_by(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id])
    if (is_at_plot)
      location_coordinates = "POINT(#{params[:position_longitude]} #{params[:position_latitude]})"
      if locationRecord.nil?
        HuntingModeUserLocation.create!(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id], hunting_location_id: params[:hunting_location_id], location_coordinates: location_coordinates)
      else
        locationRecord.update(location_coordinates: location_coordinates, hunting_location_id: params[:hunting_location_id])
      end
    elsif !locationRecord.nil?
      locationRecord.destroy
    end
  end

private
  def set_hunting_plot
    @hunting_plot = HuntingPlot.find(params[:hunting_plot_id])
  end

end
