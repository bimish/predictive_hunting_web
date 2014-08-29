class CreateAnimalActivityObservation < ActiveRecord::Migration
  def change
    create_table :animal_activity_observation do |t|
      t.references :hunting_plot, index: true, null:false
      t.references :hunting_location, index: true, null:true
      t.point :location_coordinates, null: true, :geographic => true, :srid => 4326
      t.references :animal_category, null: false
      t.integer :animal_count, limit: 2, null:false
      t.references :animal_activity_type, null:false
      t.references :hunting_plot_named_animal
      t.datetime :observation_date_time, null:false
      t.references :created_by, references: :user
      #add_index :hunting_plot_named_animal_id, name:'hunting_plot_named_animal'

      t.timestamps
    end
  end
end
