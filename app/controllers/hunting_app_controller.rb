require "app/weather_service"

class HuntingAppController < ApplicationController

  before_action :ensure_signed_in
  before_action :set_hunting_plot

  layout 'hunting_app'

  def landing_page
    @forecast = WeatherService.forecast(@hunting_plot)
    set_last_checkin
    set_location_schedules
    set_member_locations
  end

  def map
    set_location_schedules
    set_member_locations
  end

  def stands
    set_location_schedules
    set_member_locations
    set_last_checkin
  end

  def activity
    set_location_schedules
    set_member_locations
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

  def chat
    set_chat_feed
    @user_status_post = HuntingModeUserStatus.new()
    set_location_schedules
    set_member_locations
  end

  def chat_post
    @hunting_mode_user_status = HuntingModeUserStatus.new(params.require(:hunting_mode_user_status).permit(:status_text))
    @hunting_mode_user_status.init_new current_user
    @hunting_mode_user_status.hunting_plot_id = params[:hunting_plot_id]
    @hunting_mode_user_status.status_type_chat!
    @hunting_mode_user_status.save
    set_chat_feed(params[:last_post_id])
    @reset_form = true
    render action: 'chat_refresh'
  end

  def chat_refresh
    @reset_form = false
    set_chat_feed(params[:since_id])
  end

  def weather
    @forecast = WeatherService.forecast(@hunting_plot)
    @hourly_forecast = WeatherService.forecast_hourly(@hunting_plot)

    set_location_schedules
    set_member_locations
  end

  def check_in
    @status = { user_id: current_user.id }
    is_at_plot = (params[:is_at_plot] == 'true')
    @location_record = HuntingModeUserLocation.find_by(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id])
    if (is_at_plot)
      location_coordinates = "POINT(#{params[:position_longitude]} #{params[:position_latitude]})"
      if @location_record.nil?
        @location_record = HuntingModeUserLocation.create(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id], hunting_location_id: params[:hunting_location_id], location_coordinates: location_coordinates)
      else
        @location_record.update(location_coordinates: location_coordinates, hunting_location_id: params[:hunting_location_id])
      end
    elsif !@location_record.nil?
      @location_record.destroy
      @location_record = nil
    end
    if @location_record.nil? || @location_record.destroyed?
      @status[:checked_in] = false
      @status[:updated_at] = Time.now
    else
      @status[:checked_in] = true
      @status[:updated_at] = @location_record.updated_at
    end
  end

private
  def set_hunting_plot
    @hunting_plot = HuntingPlot.find(params[:hunting_plot_id])
  end

  def set_member_locations
    #@member_locations ||= HuntingModeUserLocation.where(hunting_plot_id: params[:hunting_plot_id]).where('updated_at > ?', 1.days.ago).preload(:user).preload(:hunting_location)
    @member_locations ||= HuntingModeUserLocation.non_expired_for_plot(params[:hunting_plot_id]).preload(:user).preload(:hunting_location)
  end

  def set_location_schedules
    @hunting_location_schedules = HuntingLocationSchedule.current_schedules_for_plot(@hunting_plot)
  end

  def set_chat_feed(since_item_id = nil)
    @chat_items = HuntingModeUserStatus.for_hunting_plot(@hunting_plot.id, since_item_id)
  end

  def set_last_checkin
    @last_checkin = HuntingModeUserLocation.find_by(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id])
  end
end
