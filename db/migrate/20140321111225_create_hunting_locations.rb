class CreateHuntingLocations < ActiveRecord::Migration
  def change
    create_table :hunting_locations do |t|
    	t.belongs_to :hunting_plot
      t.string :name
      t.point :coordinates
      t.integer :hunting_plot
      t.integer :type

      t.timestamps
    end
  end
end
