require 'net/http'
require 'json'

module WeatherForecastHelper

  @@api_key = 'be50215583adc47b'

  def get_weather_forecast(hunting_plot)

    location_result = get_location(hunting_plot)
    forecast_result = execute_request(hunting_plot, 'forecast', 12.hours)

    return {
      details_url: location_result['location']['wuiurl'],
      forecast: forecast_result['forecast']
    }

  end

  def get_hourly_weather_forecast(hunting_plot)

    location_result = get_location(hunting_plot)
    forecast_result = execute_request(hunting_plot, 'hourly', 1.hours)
    astronomy_result = execute_request(hunting_plot, 'astronomy', 24.hours)

    return {
      details_url: location_result['location']['wuiurl'],
      forecast: forecast_result['hourly_forecast'],
      astronomy: astronomy_result['moon_phase']
    }

  end

  def get_current_conditions(hunting_plot)

    conditions_results = execute_request(hunting_plot, 'conditions', 1.hours)
    return {
      conditions: conditions_results['current_observation']
    }

  end

  def get_location(hunting_plot)

    cache_key = "weather_geolocation_result_#{hunting_plot.id}"

    Rails.cache.fetch(cache_key, :expires_in => 24.hours) do |key|
      location_url = URI.parse("http://api.wunderground.com/api/#{@@api_key}/geolookup/q/#{hunting_plot.location_coordinates.y()},#{hunting_plot.location_coordinates.x()}.json")
      location_request = Net::HTTP::Get.new(location_url.path)
      location_response = Net::HTTP.start(location_url.host, location_url.port) do |http|
        http.request(location_request)
      end
      JSON.parse(location_response.body)
    end

  end

  def get_request_url(geolookup_result, request_type)
    URI.parse("http://api.wunderground.com/api/#{@@api_key}/#{request_type}/q/#{geolookup_result['location']['state']}/#{geolookup_result['location']['city'].gsub(/ /,'_')}.json")
  end

  def execute_request(hunting_plot, request_data, expiration = 1.hours)

    geolookup_result = get_location(hunting_plot)

    cache_key = "weather_#{request_data}_#{geolookup_result['location']['state']}_#{geolookup_result['location']['city']}"

    Rails.cache.fetch(cache_key, :expires_in => expiration) do |key|
      request_url = get_request_url(geolookup_result, request_data)
      request = Net::HTTP::Get.new(request_url.path)
      response = Net::HTTP.start(request_url.host, request_url.port) do |http|
        http.request(request)
      end
      JSON.parse(response.body)

    end

  end

end


