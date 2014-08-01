class CreateUserNetwork < ActiveRecord::Migration
  def change
    create_table :user_network do |t|
      t.string :name, null: false, limit: 100
      t.references :category, references: :user_network_category, index: true, null: false
      t.references :parent_network, references: :user_network, index: true, null: true

      t.timestamps
    end
  end
end
