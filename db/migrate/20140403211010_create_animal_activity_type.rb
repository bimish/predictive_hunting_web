class CreateAnimalActivityType < ActiveRecord::Migration
  def change
    create_table :animal_activity_type do |t|
      t.string :name, limit: 100, null: false

      t.timestamps
    end
  end
end
