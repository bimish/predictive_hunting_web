class CreateUserNetworkCategory < ActiveRecord::Migration
  def change
    create_table :user_network_category do |t|
      t.string :name, limit: 100, null: false
      t.boolean :is_composite, null: false
      t.references :parent_category, references: :user_network_category, index: true

      t.timestamps
    end
  end
end
