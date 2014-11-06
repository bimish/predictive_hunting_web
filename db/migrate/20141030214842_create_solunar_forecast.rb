class CreateSolunarForecast < ActiveRecord::Migration
  def change
    create_table :solunar_forecast do |t|
      t.references :location, references: :solunar_forecast_location, null: false, index: true
      t.date :forecast_day, null: false, index: true
      t.time :minor_am
      t.time :major_am
      t.time :minor_pm
      t.time :major_pm
      t.time :sun_rise, null: false
      t.time :sun_set, null: false
      t.time :moon_rise
      t.time :moon_set
      t.time :moon_up
      t.time :moon_down
      t.integer :moon_phase, limit: 2
      t.integer :activity_indicator, limit: 2
      t.timestamps
    end
  end
end
