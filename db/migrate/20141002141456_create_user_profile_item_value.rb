class CreateUserProfileItemValue < ActiveRecord::Migration
  def change
    create_table :user_profile_item_value do |t|
      t.references :user, null: false, index: true
      t.references :user_profile_item, null: false
      t.integer :value_number, null: true
      t.string :value, null: false, limit: 255
      t.timestamps
    end
    add_index :user_profile_item_value, [:user_id, :user_profile_item_id, :value_number], :unique => true, name:'idx_user_item_value_number'
  end
end
