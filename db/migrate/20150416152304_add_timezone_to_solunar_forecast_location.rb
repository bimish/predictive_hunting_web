class AddTimezoneToSolunarForecastLocation < ActiveRecord::Migration

  def up
    add_column :solunar_forecast_location, :time_zone, :string
    SolunarForecastLocation.find_each do |location|
      location.time_zone = 'America/New_York'
      location.save!
    end
  end

  def down
    remove_column :solunar_forecast_location, :time_zone
  end

end
