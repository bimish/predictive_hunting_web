class CreateHuntingLocationUserAccess < ActiveRecord::Migration
  def change
    create_table :hunting_location_user_access do |t|
      t.references :user, index: true, null:false
      t.references :hunting_location, index: true, null:false
      t.integer :access_flags, null:false, default:0
      t.datetime :expires_at

      t.timestamps
    end
    add_index :hunting_location_user_access, [:hunting_location_id, :user_id, ], :unique => true, name:'idx_hunting_location_user_access_location_and_user'
  end
end
