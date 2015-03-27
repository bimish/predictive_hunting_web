require "app/weather_service"

class HuntingAppController < ApplicationController

  before_action :ensure_signed_in
  before_action :set_hunting_plot

  layout 'hunting_app'

  def landing_page
    @forecast = WeatherService.forecast(@hunting_plot)
  end

  def map
    set_location_schedules_for_week
    set_member_locations

    @wind_forecast = []

    hourly_forecast = WeatherForecastHelper.forecast_hourly(@hunting_plot)
    if hourly_forecast[:forecast][0].nil?
      todays_forecast = {
        wind_dir: 'Unavailable',
        wind_degrees: '0',
        wind_mph: '?'
      }
    else
      todays_forecast = {
        wind_dir: hourly_forecast[:forecast][0]['wdir']['dir'],
        wind_degrees: hourly_forecast[:forecast][0]['wdir']['degrees'],
        wind_mph: hourly_forecast[:forecast][0]['wspd']['english']
      }
    end
    todays_forecast[:date] = Date.today
    @wind_forecast.push todays_forecast

    ten_day_forecast = WeatherService.forecast_10_day(@hunting_plot)
    ((Date.today + 1)..(Date.today + 7)).each do |date|
      day_forecast = ten_day_forecast[:forecast]['simpleforecast']['forecastday'].detect do |forecast_day|
        forecast_day['date']['year'] == date.year && forecast_day['date']['month'] == date.month && forecast_day['date']['day'] == date.day
      end
      unless day_forecast.nil?
        forecast_item =
          {
            date: date,
            wind_dir: day_forecast['avewind']['dir'],
            wind_degrees: day_forecast['avewind']['degrees'],
            wind_mph: day_forecast['avewind']['mph']
          }
        @wind_forecast.push forecast_item
      end
    end

  end

  def stand_checkin

    set_location_schedules_for_week
    set_member_locations
    set_last_checkin
    @reservations = HuntingLocationSchedule.schedules_for_plot(@hunting_plot, Time.now.beginning_of_day, 1.weeks.from_now.end_of_day)

    @wind_forecast = []

    hourly_forecast = WeatherForecastHelper.forecast_hourly(@hunting_plot)
    if hourly_forecast[:forecast][0].nil?
      todays_forecast = {
        wind_dir: 'Unavailable',
        wind_degrees: '0',
        wind_mph: '?'
      }
    else
      todays_forecast = {
        wind_dir: hourly_forecast[:forecast][0]['wdir']['dir'],
        wind_degrees: hourly_forecast[:forecast][0]['wdir']['degrees'],
        wind_mph: hourly_forecast[:forecast][0]['wspd']['english']
      }
    end
    todays_forecast[:date] = Date.today
    @wind_forecast.push todays_forecast

    ten_day_forecast = WeatherService.forecast_10_day(@hunting_plot)
    ((Date.today + 1)..(Date.today + 7)).each do |date|
      day_forecast = ten_day_forecast[:forecast]['simpleforecast']['forecastday'].detect do |forecast_day|
        forecast_day['date']['year'] == date.year && forecast_day['date']['month'] == date.month && forecast_day['date']['day'] == date.day
      end
      unless day_forecast.nil?
        forecast_item =
          {
            date: date,
            wind_dir: day_forecast['avewind']['dir'],
            wind_degrees: day_forecast['avewind']['degrees'],
            wind_mph: day_forecast['avewind']['mph']
          }
        @wind_forecast.push forecast_item
      end
    end

  end

  def stands
    hourly_forecast = WeatherService.forecast_hourly(@hunting_plot)
    if hourly_forecast[:forecast][0].nil?
      @wind_forecast = {
        wind_dir: 'Unavailable',
        wind_degrees: '0',
        wind_mph: '?'
      }
    else
      @wind_forecast = {
        wind_dir: hourly_forecast[:forecast][0]['wdir']['dir'],
        wind_degrees: hourly_forecast[:forecast][0]['wdir']['degrees'],
        wind_mph: hourly_forecast[:forecast][0]['wspd']['english']
      }
    end.to_json
    set_location_schedules_for_today
    set_member_locations
    set_last_checkin
  end

  def activity

    set_activity_history
    @new_observation = AnimalActivityObservation.new
    @view_data = ViewData.new(@hunting_plot)

  end

  def activity_record
    @animal_activity_observation = AnimalActivityObservation.new
    @animal_activity_observation.hunting_plot_id = @hunting_plot.id
    @animal_activity_observation.init_new current_user
    if params[:observation_date_time_offset] == "another"
      unless params[:observation_date].blank? || params[:observation_time].blank?
        date = Date.parse(params[:observation_date])
        time = Time.zone.parse(params[:observation_time])
        @animal_activity_observation.observation_date_time = DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, time.zone)
      end
    else
      @animal_activity_observation.observation_date_time = params[:observation_date_time_offset].to_i.minutes.ago
    end

    unless params[:hunting_location_id].blank?
      if params[:hunting_location_id] == "0"
        current_checkin = HuntingModeUserLocation.find_by(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id])
        if current_checkin.nil? || current_checkin.expired? || current_checkin.hunting_location_id.nil?
          unless params[:location_coordinates_lat].blank? || params[:location_coordinates_lng].blank?
            @animal_activity_observation.location_coordinates = "POINT(#{params[:location_coordinates_lng]} #{params[:location_coordinates_lat]})"
          end
        else
          @animal_activity_observation.hunting_location_id = current_checkin.hunting_location_id
        end
      else
        @animal_activity_observation.hunting_location_id = params[:hunting_location_id]
      end
    end

    if (params[:animal_category_id] == 'named')
      @animal_activity_observation.hunting_plot_named_animal_id = params[:hunting_plot_named_animal_id]
      named_animal = HuntingPlotNamedAnimal.find(params[:hunting_plot_named_animal_id])
      @animal_activity_observation.animal_count = 1
      @animal_activity_observation.animal_category_id = named_animal.animal_category_id
    else
      @animal_activity_observation.animal_count = params[:animal_count]
      @animal_activity_observation.animal_category_id = params[:animal_category_id]
    end

    unless params[:animal_activity_type_id].blank?
      @animal_activity_observation.animal_activity_type_id = params[:animal_activity_type_id]
    end

    @animal_activity_observation.save

  end

  def activity_history
    set_activity_history
  end

  def chat
    set_chat_feed
    @user_status_post = HuntingModeUserStatus.new()
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
  end

  def check_in
    @status = { user_id: current_user.id }
    is_at_plot = (params[:is_at_plot] == 'true')
    @location_record = HuntingModeUserLocation.find_by(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id])
    if (is_at_plot)
      location_coordinates = "POINT(#{params[:position_longitude]} #{params[:position_latitude]})"
      expires_at = Time.parse(params[:expires_at]) # this returns the supplied time on the current day in the current time zone
      location_id = params[:hunting_location_id]
      if location_id == '0'
        location_id = nil
      end
      if @location_record.nil?
        @location_record = HuntingModeUserLocation.create(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id], hunting_location_id: location_id, location_coordinates: location_coordinates, expires_at: expires_at)
      else
        @location_record.touch # ensure updated_at gets changed
        @location_record.update(location_coordinates: location_coordinates, hunting_location_id: location_id, expires_at: expires_at)
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

  def stand_checkin_dialog
    set_hunting_plot
    @hunting_location = HuntingLocation.find(params[:hunting_location_id])
    @checked_in_user = HuntingModeUserLocation.current_for_location(@hunting_location.id)
    @existing_reservations = HuntingLocationSchedule.schedules_for_location(@hunting_location, Date.current.beginning_of_day, Date.current.end_of_day)
  end

  def stand_reservation_dialog
    set_hunting_plot
    @hunting_location = HuntingLocation.find(params[:hunting_location_id])
    @reservation_date = params[:reservation_date].blank? ? Date.today : Date.parse(params[:reservation_date])
    # get all reservations of this location for the next 7 days
    @existing_reservations = HuntingLocationSchedule.schedules_for_location(@hunting_location, Date.current.beginning_of_day, 6.days.from_now.end_of_day)
  end

  def create_stand_reservation

    @action_taken = {}

    if (params[:existing_reservation_id].blank?)
      @reservation = HuntingLocationSchedule.new(
        hunting_location_id: params[:hunting_location_id],
        start_date_time: params[:reservation_date],
        end_date_time: params[:reservation_date],
        entry_type: HuntingLocationSchedule.entry_types[:entry_type_reservation]
      )
      @reservation.init_new current_user
      @action_taken[:action] = :create
    else
      @reservation = HuntingLocationSchedule.find(params[:existing_reservation_id])
      @action_taken[:reservation_id] = @reservation.id
      @action_taken[:action] = :update
    end

    @reservation.time_period = params[:time_period]
=begin
    reserve_am = !params[:reserve_am].blank?
    reserve_pm = !params[:reserve_pm].blank?
    if (reserve_am && reserve_pm)
      @reservation.time_period_all_day!
    elsif reserve_am
      @reservation.time_period_am!
    elsif reserve_pm
      @reservation.time_period_pm!
    else
      if (@reservation.persisted?)
        @action_taken[:action] = :delete
        @reservation.destroy
      end
      @reservation = nil
    end
=end
    unless @reservation.nil?
      @reservation.save
    end

  end

  def hunt_forecast
    forecast_location = SolunarForecastLocation.nearest_to_plot(@hunting_plot)
    @month_forecast = SolunarForecast.for_month(forecast_location.id).order(forecast_day: :asc)
    today = Date.today
    @forecast_date = today.beginning_of_month
    @day_forecast = @month_forecast.find { |daily_forecast| daily_forecast.forecast_day == today }
  end

  def hunt_forecast_month
    @forecast_date = params[:forecast_date].blank? ? Date.today.beginning_of_month : Date.parse(params[:forecast_date]).beginning_of_month
    forecast_location = SolunarForecastLocation.nearest_to_plot(@hunting_plot)
    @forecast = SolunarForecast.for_month(forecast_location.id, @forecast_date).order(forecast_day: :asc)
  end


private
  def set_hunting_plot
    @hunting_plot = HuntingPlot.find(params[:hunting_plot_id])
    if !@hunting_plot.authorize_action?(current_user, :read)
      flash[:alert] = 'The current user does not have access to the specified plot'
      render 'authorization_failure', :layout => false
    end
  end

  def set_member_locations
    #@member_locations ||= HuntingModeUserLocation.where(hunting_plot_id: params[:hunting_plot_id]).where('updated_at > ?', 1.days.ago).preload(:user).preload(:hunting_location)
    @member_locations ||= HuntingModeUserLocation.non_expired_for_plot(params[:hunting_plot_id]).preload(:user).preload(:hunting_location)
  end

  def set_location_schedules_for_today
    @hunting_location_schedules = HuntingLocationSchedule.schedules_for_plot(@hunting_plot, Time.now, Time.now.end_of_day)
  end

  def set_location_schedules_for_week
    @hunting_location_schedules = HuntingLocationSchedule.schedules_for_plot(@hunting_plot, Time.now.beginning_of_day, 1.weeks.from_now.end_of_day)
  end

  def set_chat_feed(since_item_id = nil)
    @chat_items = HuntingModeUserStatus.for_hunting_plot(@hunting_plot.id, since_item_id)
  end

  def set_last_checkin
    @last_checkin = HuntingModeUserLocation.find_by(user_id: current_user.id, hunting_plot_id: params[:hunting_plot_id])
  end

  def set_activity_history
    @animal_activity_observations = AnimalActivityObservation.search(@hunting_plot.id, params).preload(:hunting_location).preload(:named_animal)
=begin
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

    unless params[:hunting_location_id].blank?
      location_ids = params[:hunting_location_id]
      locations = named_animal_ids.collect { |named_animal_id| HuntingPlotNamedAnimal.find(named_animal_id.to_i).name }
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
=end
  end

  class ViewData

    def initialize(hunting_plot)
      @hunting_plot = hunting_plot
    end

    def hunting_locations
      @locations_map ||= @hunting_plot.locations.map { |m| [m.name, m.id] }
    end

    def animal_categories
      @animal_categories_map ||= AnimalCategory.all.map { |m| [m.name, m.id] }
    end

    def animal_activity_types
      @animal_activity_types_map ||= AnimalActivityType.all.map { |m| [m.name, m.id] }
    end

    def named_animals
      @named_animals ||= @hunting_plot.named_animals.map { |m| [m.name, m.id] }
    end

  end

end
