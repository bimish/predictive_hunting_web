class CreateUserNetwork < ActiveRecord::Migration
  def change
    create_table :user_network do |t|
      t.string :name, null: false, limit: 100
      t.integer :network_type, null: false

      t.timestamps
    end
  end
end
