class CreateHuntingLocationTemporaryAccess < ActiveRecord::Migration
  def change
    create_table :hunting_location_temporary_access do |t|
      t.references :hunting_location, index: true, null:false
      t.references :user, index: true, null:false
      t.references :granted_by, references: :user
      t.datetime :starts_at, null:false
      t.datetime :ends_at, null:false
      t.integer :status, limit: 2, null: false, default: 0

      t.timestamps
    end
  end
end
