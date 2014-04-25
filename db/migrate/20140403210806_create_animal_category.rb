class CreateAnimalCategory < ActiveRecord::Migration
  def change
    create_table :animal_category do |t|
      t.references :animal_species, index: true, null: false
      t.string :name, limit: 100, null: false
      t.integer :gender, limit: 2, null: false
      t.integer :maturity, limit: 2, null: false
      t.integer :trophy_rating, limit: 2

      t.timestamps
    end
  end
end
