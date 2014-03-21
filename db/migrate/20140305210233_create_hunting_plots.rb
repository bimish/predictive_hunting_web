class CreateHuntingPlots < ActiveRecord::Migration
  def change
    create_table :hunting_plots do |t|
      t.string :name, :null => false, :limit => 100
      t.point :location_coordinates, :null => false, :geographic => true, :srid => 4326
      t.polygon :boundary
      t.timestamps
    end
  end
end
