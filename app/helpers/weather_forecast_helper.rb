require 'net/http'
require 'json'

module WeatherForecastHelper

  def get_weather_forecast(hunting_plot)

    #forecast_result = JSON.parse(dummy_forecast)

    location_url = URI.parse("http://api.wunderground.com/api/be50215583adc47b/geolookup/q/#{hunting_plot.location_coordinates.y()},#{hunting_plot.location_coordinates.x()}.json")
    location_request = Net::HTTP::Get.new(location_url.path)
    location_response = Net::HTTP.start(location_url.host, location_url.port) do |http|
      http.request(location_request)
    end
    location_result = JSON.parse(location_response.body)

    forecast_url = URI.parse("http://api.wunderground.com/api/be50215583adc47b/forecast/q/#{location_result['location']['state']}/#{location_result['location']['city'].gsub(/ /,'_')}.json")
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

    #forecast_result = JSON.parse(dummy_forecast)

    location_url = URI.parse("http://api.wunderground.com/api/be50215583adc47b/geolookup/q/#{hunting_plot.location_coordinates.y()},#{hunting_plot.location_coordinates.x()}.json")
    location_request = Net::HTTP::Get.new(location_url.path)
    location_response = Net::HTTP.start(location_url.host, location_url.port) do |http|
      http.request(location_request)
    end
    location_result = JSON.parse(location_response.body)

    forecast_url = URI.parse("http://api.wunderground.com/api/be50215583adc47b/hourly/q/#{location_result['location']['state']}/#{location_result['location']['city'].gsub(/ /,'_')}.json")
    forecast_request = Net::HTTP::Get.new(forecast_url.path)
    forecast_response = Net::HTTP.start(forecast_url.host, forecast_url.port) do |http|
      http.request(forecast_request)
    end
    forecast_result = JSON.parse(forecast_response.body)

    astronomy_url = URI.parse("http://api.wunderground.com/api/be50215583adc47b/astronomy/q/#{location_result['location']['state']}/#{location_result['location']['city'].gsub(/ /,'_')}.json")
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

  def dummy_forecast
    '{
       "response":{
          "version":"0.1",
          "termsofService":"http://www.wunderground.com/weather/api/d/terms.html",
          "features":{
             "forecast":1
          }
       },
       "forecast":{
          "txt_forecast":{
             "date":"6:20 PM EDT",
             "forecastday":[
                {
                   "period":0,
                   "icon":"partlycloudy",
                   "icon_url":"http://icons.wxug.com/i/c/k/partlycloudy.gif",
                   "title":"Tuesday",
                   "fcttext":"Mix of sun and clouds. Lows overnight in the low 70s.",
                   "fcttext_metric":"Partly cloudy. Lows overnight 20 to 22.",
                   "pop":"20"
                },
                {
                   "period":1,
                   "icon":"nt_partlycloudy",
                   "icon_url":"http://icons.wxug.com/i/c/k/nt_partlycloudy.gif",
                   "title":"Tuesday Night",
                   "fcttext":"Partly cloudy skies. Low near 70F. Winds SSW at 5 to 10 mph.",
                   "fcttext_metric":"Some clouds. Low 21C. Winds SSW at 10 to 15 kph.",
                   "pop":"20"
                },
                {
                   "period":2,
                   "icon":"chancetstorms",
                   "icon_url":"http://icons.wxug.com/i/c/k/chancetstorms.gif",
                   "title":"Wednesday",
                   "fcttext":"Partly cloudy in the morning then heavy thunderstorms later in the day. High around 85F. Winds S at 5 to 10 mph. Chance of rain 90%.",
                   "fcttext_metric":"Partly cloudy skies early with heavy thunderstorms developing in the afternoon. High 29C. Winds S at 10 to 15 kph. Chance of rain 90%.",
                   "pop":"90"
                },
                {
                   "period":3,
                   "icon":"nt_tstorms",
                   "icon_url":"http://icons.wxug.com/i/c/k/nt_tstorms.gif",
                   "title":"Wednesday Night",
                   "fcttext":"Thunderstorms likely in the evening. Then the chance of scattered thunderstorms later on. Low 67F. Winds S at 5 to 10 mph. Chance of rain 90%.",
                   "fcttext_metric":"Thunderstorms likely in the evening. Then the chance of scattered thunderstorms later on. Low 20C. Winds S at 10 to 15 kph. Chance of rain 90%.",
                   "pop":"90"
                },
                {
                   "period":4,
                   "icon":"chancetstorms",
                   "icon_url":"http://icons.wxug.com/i/c/k/chancetstorms.gif",
                   "title":"Thursday",
                   "fcttext":"Scattered thunderstorms. High 84F. Winds SW at 5 to 10 mph. Chance of rain 50%.",
                   "fcttext_metric":"Scattered showers and thunderstorms. High 29C. Winds SW at 10 to 15 kph. Chance of rain 50%.",
                   "pop":"50"
                },
                {
                   "period":5,
                   "icon":"nt_chancetstorms",
                   "icon_url":"http://icons.wxug.com/i/c/k/nt_chancetstorms.gif",
                   "title":"Thursday Night",
                   "fcttext":"Scattered thunderstorms early. Skies will become mainly clear overnight. Low 66F. Winds SW at 5 to 10 mph. Chance of rain 50%.",
                   "fcttext_metric":"Scattered thunderstorms early. Skies will become mainly clear overnight. Low 19C. Winds SW at 10 to 15 kph. Chance of rain 50%.",
                   "pop":"50"
                },
                {
                   "period":6,
                   "icon":"clear",
                   "icon_url":"http://icons.wxug.com/i/c/k/clear.gif",
                   "title":"Friday",
                   "fcttext":"Generally sunny despite a few afternoon clouds. High 88F. Winds WSW at 5 to 10 mph.",
                   "fcttext_metric":"Generally sunny despite a few afternoon clouds. High 31C. Winds WSW at 10 to 15 kph.",
                   "pop":"20"
                },
                {
                   "period":7,
                   "icon":"nt_chancetstorms",
                   "icon_url":"http://icons.wxug.com/i/c/k/nt_chancetstorms.gif",
                   "title":"Friday Night",
                   "fcttext":"Isolated thunderstorms during the evening, then skies turning partly cloudy overnight. Low 68F. Winds light and variable. Chance of rain 30%.",
                   "fcttext_metric":"Isolated thunderstorms during the evening, then skies turning partly cloudy overnight. Low 20C. Winds light and variable. Chance of rain 30%.",
                   "pop":"30"
                }
             ]
          },
          "simpleforecast":{
             "forecastday":[
                {
                   "date":{
                      "epoch":"1402441200",
                      "pretty":"7:00 PM EDT on June 10, 2014",
                      "day":10,
                      "month":6,
                      "year":2014,
                      "yday":160,
                      "hour":19,
                      "min":"00",
                      "sec":0,
                      "isdst":"1",
                      "monthname":"June",
                      "monthname_short":"Jun",
                      "weekday_short":"Tue",
                      "weekday":"Tuesday",
                      "ampm":"PM",
                      "tz_short":"EDT",
                      "tz_long":"America/New_York"
                   },
                   "period":1,
                   "high":{
                      "fahrenheit":"95",
                      "celsius":"34"
                   },
                   "low":{
                      "fahrenheit":"70",
                      "celsius":"21"
                   },
                   "conditions":"Partly Cloudy",
                   "icon":"partlycloudy",
                   "icon_url":"forecast-cloudy.png",
                   "skyicon":"",
                   "pop":20,
                   "qpf_allday":{
                      "in":0.00,
                      "mm":0
                   },
                   "qpf_day":{
                      "in":null,
                      "mm":null
                   },
                   "qpf_night":{
                      "in":0.00,
                      "mm":0
                   },
                   "snow_allday":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "snow_day":{
                      "in":null,
                      "cm":null
                   },
                   "snow_night":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "maxwind":{
                      "mph":12,
                      "kph":18,
                      "dir":"SW",
                      "degrees":0
                   },
                   "avewind":{
                      "mph":2,
                      "kph":3,
                      "dir":"SSW",
                      "degrees":0
                   },
                   "avehumidity":76,
                   "maxhumidity":0,
                   "minhumidity":0
                },
                {
                   "date":{
                      "epoch":"1402527600",
                      "pretty":"7:00 PM EDT on June 11, 2014",
                      "day":11,
                      "month":6,
                      "year":2014,
                      "yday":161,
                      "hour":19,
                      "min":"00",
                      "sec":0,
                      "isdst":"1",
                      "monthname":"June",
                      "monthname_short":"Jun",
                      "weekday_short":"Wed",
                      "weekday":"Wednesday",
                      "ampm":"PM",
                      "tz_short":"EDT",
                      "tz_long":"America/New_York"
                   },
                   "period":2,
                   "high":{
                      "fahrenheit":"85",
                      "celsius":"29"
                   },
                   "low":{
                      "fahrenheit":"67",
                      "celsius":"19"
                   },
                   "conditions":"Chance of a Thunderstorm",
                   "icon":"chancetstorms",
                   "icon_url":"forecast-thunderstorms.png",
                   "skyicon":"",
                   "pop":90,
                   "qpf_allday":{
                      "in":0.98,
                      "mm":25
                   },
                   "qpf_day":{
                      "in":0.53,
                      "mm":13
                   },
                   "qpf_night":{
                      "in":0.45,
                      "mm":11
                   },
                   "snow_allday":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "snow_day":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "snow_night":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "maxwind":{
                      "mph":10,
                      "kph":16,
                      "dir":"S",
                      "degrees":186
                   },
                   "avewind":{
                      "mph":8,
                      "kph":13,
                      "dir":"S",
                      "degrees":186
                   },
                   "avehumidity":92,
                   "maxhumidity":0,
                   "minhumidity":0
                },
                {
                   "date":{
                      "epoch":"1402614000",
                      "pretty":"7:00 PM EDT on June 12, 2014",
                      "day":12,
                      "month":6,
                      "year":2014,
                      "yday":162,
                      "hour":19,
                      "min":"00",
                      "sec":0,
                      "isdst":"1",
                      "monthname":"June",
                      "monthname_short":"Jun",
                      "weekday_short":"Thu",
                      "weekday":"Thursday",
                      "ampm":"PM",
                      "tz_short":"EDT",
                      "tz_long":"America/New_York"
                   },
                   "period":3,
                   "high":{
                      "fahrenheit":"84",
                      "celsius":"29"
                   },
                   "low":{
                      "fahrenheit":"66",
                      "celsius":"19"
                   },
                   "conditions":"Chance of a Thunderstorm",
                   "icon":"chancetstorms",
                   "icon_url":"forecast-thunderstorms.png",
                   "skyicon":"",
                   "pop":50,
                   "qpf_allday":{
                      "in":0.20,
                      "mm":5
                   },
                   "qpf_day":{
                      "in":0.14,
                      "mm":4
                   },
                   "qpf_night":{
                      "in":0.06,
                      "mm":2
                   },
                   "snow_allday":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "snow_day":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "snow_night":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "maxwind":{
                      "mph":10,
                      "kph":16,
                      "dir":"SW",
                      "degrees":226
                   },
                   "avewind":{
                      "mph":8,
                      "kph":13,
                      "dir":"SW",
                      "degrees":226
                   },
                   "avehumidity":87,
                   "maxhumidity":0,
                   "minhumidity":0
                },
                {
                   "date":{
                      "epoch":"1402700400",
                      "pretty":"7:00 PM EDT on June 13, 2014",
                      "day":13,
                      "month":6,
                      "year":2014,
                      "yday":163,
                      "hour":19,
                      "min":"00",
                      "sec":0,
                      "isdst":"1",
                      "monthname":"June",
                      "monthname_short":"Jun",
                      "weekday_short":"Fri",
                      "weekday":"Friday",
                      "ampm":"PM",
                      "tz_short":"EDT",
                      "tz_long":"America/New_York"
                   },
                   "period":4,
                   "high":{
                      "fahrenheit":"88",
                      "celsius":"31"
                   },
                   "low":{
                      "fahrenheit":"68",
                      "celsius":"20"
                   },
                   "conditions":"Clear",
                   "icon":"clear",
                   "icon_url":"forecast-sunny.png",
                   "skyicon":"",
                   "pop":20,
                   "qpf_allday":{
                      "in":0.03,
                      "mm":1
                   },
                   "qpf_day":{
                      "in":0.01,
                      "mm":0
                   },
                   "qpf_night":{
                      "in":0.02,
                      "mm":1
                   },
                   "snow_allday":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "snow_day":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "snow_night":{
                      "in":0.0,
                      "cm":0.0
                   },
                   "maxwind":{
                      "mph":10,
                      "kph":16,
                      "dir":"WSW",
                      "degrees":257
                   },
                   "avewind":{
                      "mph":6,
                      "kph":10,
                      "dir":"WSW",
                      "degrees":257
                   },
                   "avehumidity":82,
                   "maxhumidity":0,
                   "minhumidity":0
                }
             ]
          }
       }
    }'
  end

end

