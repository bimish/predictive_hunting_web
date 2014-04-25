class CreateAnimalActivityObservation < ActiveRecord::Migration
  def change
    create_table :animal_activity_observation do |t|
      t.references :hunting_location, index: true, null:false
      t.references :animal_category, index: true, null: false
      t.integer :animal_count, limit: 2, null:false
      t.references :animal_activity_type, index: true, null:false
      t.references :hunting_plot_named_animal
      t.datetime :observation_date_time, null:false
      #add_index :hunting_plot_named_animal_id, name:'hunting_plot_named_animal'

      t.timestamps
    end
  end
end
