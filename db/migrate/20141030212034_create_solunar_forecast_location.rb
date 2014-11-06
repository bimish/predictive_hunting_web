class CreateSolunarForecastLocation < ActiveRecord::Migration
  def change
    create_table :solunar_forecast_location do |t|
      t.string :name, null: false, limit: 100
      t.point :location_coordinates, null: false, :geographic => true, :srid => 4326
      t.timestamps
    end
  end
end
