class CreateAnimalSpecies < ActiveRecord::Migration
  def change
    create_table :animal_species do |t|
      t.string :common_name, limit: 100, null: false
      t.string :species, limit: 255, null: false

      t.timestamps
    end
  end
end
