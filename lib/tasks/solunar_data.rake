namespace :db do
  namespace :solunar do

    desc 'Fills in moon phases for a solunar location'
    task :moon_phases, [:location_id] => [:environment] do |t, args|
      if args[:location_id].blank?
        puts 'You must provide a location id, i.e., -> rake db:solunar.moon_phases[2]'
      else
        fix_moon_phases args[:location_id]
      end
    end

  end
end

def fix_moon_phases(location_id)
  known_phase_forecasts = SolunarForecast.where(location_id: location_id).where(moon_phase: [0,50,100]).order(forecast_day: :asc)
  for index in 0..(known_phase_forecasts.size - 2)
    start_date = known_phase_forecasts[index].forecast_day
    end_date = known_phase_forecasts[index + 1].forecast_day
    forecasts_to_fix = SolunarForecast.where(location_id: location_id).where('forecast_day > ?', start_date).where('forecast_day < ?', end_date).order(forecast_day: :asc)
    start_phase = known_phase_forecasts[index].moon_phase
    end_phase = known_phase_forecasts[index + 1].moon_phase
    difference = end_phase - start_phase
    span = forecasts_to_fix.size + 1
    forecasts_to_fix.each_with_index do |forecast, index|
      forecast.update_attribute :moon_phase, (start_phase + (difference.to_f * (index + 1).to_f / span)).round
    end
  end
end
