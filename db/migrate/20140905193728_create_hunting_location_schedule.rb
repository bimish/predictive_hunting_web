class CreateHuntingLocationSchedule < ActiveRecord::Migration
  def change
    create_table :hunting_location_schedule do |t|
      t.references :created_by, references: :user, index: true, null: false
      t.references :hunting_location, null: false, index: true
      t.datetime :start_date_time, null:false
      t.datetime :end_date_time, null:false
      t.integer :entry_type, limit: 2, null: false
      t.timestamps
    end
  end
end
