class CreateHuntingPlot < ActiveRecord::Migration
  def change
    create_table :hunting_plot do |t|
      t.string :name, null: false, limit: 100
      t.string :location_address, null: false, limit: 255
      t.point :location_coordinates, null: false, :geographic => true, :srid => 4326
      t.polygon :boundary, :srid => 4326

      t.timestamps
    end
  end
end
