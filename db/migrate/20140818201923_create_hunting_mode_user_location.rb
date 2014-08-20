class CreateHuntingModeUserLocation < ActiveRecord::Migration
  def change
    create_table :hunting_mode_user_location do |t|
      t.references :hunting_plot, index: true, null: false
      t.references :user, index: true, null: false
      t.point :location_coordinates, null: false, :geographic => true, :srid => 4326
      t.timestamps
    end
  end
end
