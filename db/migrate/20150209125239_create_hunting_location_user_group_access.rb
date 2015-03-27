class CreateHuntingLocationUserGroupAccess < ActiveRecord::Migration
  def change
    create_table :hunting_location_user_group_access do |t|
      t.references :hunting_location, index: true, null: false
      t.references :user_group, index: true, null: false
      t.integer :access_flags, null: false, default: 0

      t.timestamps
    end
    add_index :hunting_location_user_group_access, [:hunting_location_id, :user_group_id], :unique => true, name:'idx_hunting_location_user_group_access_location_and_group'
  end
end
