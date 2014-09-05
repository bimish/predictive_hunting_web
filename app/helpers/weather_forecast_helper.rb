require 'net/http'
require 'json'

module WeatherForecastHelper

  def get_weather_forecast(hunting_plot)

    location_result = get_location(hunting_plot)

    forecast_url = get_request_url(location_result, 'forecast')
    forecast_request = Net::HTTP::Get.new(forecast_url.path)
    forecast_response = Net::HTTP.start(forecast_url.host, forecast_url.port) do |http|
      http.request(forecast_request)
    end
    forecast_result = JSON.parse(forecast_response.body)

    return {
      details_url: location_result['location']['wuiurl'],
      forecast: forecast_result['forecast']
    }

  end

  def get_hourly_weather_forecast(hunting_plot)

    location_result = get_location(hunting_plot)

    forecast_url = get_request_url(location_result, 'hourly')
    forecast_request = Net::HTTP::Get.new(forecast_url.path)
    forecast_response = Net::HTTP.start(forecast_url.host, forecast_url.port) do |http|
      http.request(forecast_request)
    end
    forecast_result = JSON.parse(forecast_response.body)

    astronomy_url = get_request_url(location_result, 'astronomy')
    astronomy_request = Net::HTTP::Get.new(astronomy_url.path)
    astronomy_response = Net::HTTP.start(astronomy_url.host, astronomy_url.port) do |http|
      http.request(astronomy_request)
    end
    astronomy_result = JSON.parse(astronomy_response.body)

    return {
      details_url: location_result['location']['wuiurl'],
      forecast: forecast_result['hourly_forecast'],
      astronomy: astronomy_result['moon_phase']
    }

  end

  def get_current_conditions(hunting_plot)

    location_result = get_location(hunting_plot)

    conditions_url = get_request_url(location_result, 'conditions')
    conditions_request = Net::HTTP::Get.new(conditions_url.path)
    conditions_response = Net::HTTP.start(forecast_url.host, forecast_url.port) do |http|
      http.request(forecast_request)
    end
    forecast_result = JSON.parse(forecast_response.body)

    return {
      details_url: location_result['location']['wuiurl'],
      forecast: forecast_result['forecast']
    }

  end

  def get_location(hunting_plot)
    location_url = URI.parse("http://api.wunderground.com/api/be50215583adc47b/geolookup/q/#{hunting_plot.location_coordinates.y()},#{hunting_plot.location_coordinates.x()}.json")
    location_request = Net::HTTP::Get.new(location_url.path)
    location_response = Net::HTTP.start(location_url.host, location_url.port) do |http|
      http.request(location_request)
    end
    JSON.parse(location_response.body)
  end

  def get_request_url(geolookup_result, request_type)
    URI.parse("http://api.wunderground.com/api/be50215583adc47b/#{request_type}/q/#{geolookup_result['location']['state']}/#{geolookup_result['location']['city'].gsub(/ /,'_')}.json")
  end

  def execute_request(hunting_plot, request_data)

    geolocation_result = get_location(hunting_plot)

    request_url = get_request_url(geolocation_result, request_data)
    request = Net::HTTP::Get.new(request_url.path)
    response = Net::HTTP.start(request_url.host, request_url.port) do |http|
      http.request(request)
    end
    JSON.parse(forecast_response.body)

  end

end

