class CreateHuntingModeUserLocation < ActiveRecord::Migration
  def change
    create_table :hunting_mode_user_location do |t|
      t.references :hunting_plot, index: true, null: false
      t.references :user, index: true, null: false
      t.references :hunting_location, null: true
      t.point :location_coordinates, null: true, :geographic => true, :srid => 4326
      t.timestamps
    end
    add_index :hunting_mode_user_location, [:user_id, :hunting_plot_id], :unique => true, name:'idx_hunting_mode_user_location_on_plot_and_hunter'
  end
end
