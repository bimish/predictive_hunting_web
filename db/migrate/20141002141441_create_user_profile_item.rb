class CreateUserProfileItem < ActiveRecord::Migration
  def change
    create_table :user_profile_item do |t|
      t.string :name, null: false, limit: 100, index: true, null: false
      t.string :label, null: false, limit: 255, null: false
      t.integer :data_type, limit: 2, null: false
      t.integer :flags, null: false
      t.string :validation_expression, null: true, limit: 512
      t.string :validation_message, null: true, limit: 255
      t.text :value_list, null: true
      t.timestamps
    end
  end
end
