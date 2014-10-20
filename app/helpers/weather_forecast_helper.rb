require 'net/http'
require 'json'
require "app/weather_service"

module WeatherForecastHelper

  def self.forecast(hunting_plot)
    WeatherService.forecast(hunting_plot)
  end

  def self.forecast_10_day(hunting_plot)
    WeatherService.forecast_10_day(hunting_plot)
  end

  def self.forecast_hourly(hunting_plot)
    WeatherService.forecast_hourly(hunting_plot)
  end

  def self.current_conditions(hunting_plot)
    WeatherService.current_conditions(hunting_plot)
  end

end


