class CreateHuntingLocation < ActiveRecord::Migration
  def change
    create_table :hunting_location do |t|
    	t.belongs_to :hunting_plot
      t.string :name, null: false, limit: 100
      t.point :coordinates, null: false, :geographic => true, :srid => 4326
      t.references :hunting_plot, null: false, index: true
      t.integer :location_type, null: false

      t.timestamps
    end
  end
end
