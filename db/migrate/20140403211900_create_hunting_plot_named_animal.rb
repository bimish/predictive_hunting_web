class CreateHuntingPlotNamedAnimal < ActiveRecord::Migration
  def change
    create_table :hunting_plot_named_animal do |t|
      t.belongs_to :hunting_plot
      t.references :hunting_plot, index: true, null:false
      t.string :name, limit: 100, null:false
      t.references :animal_category, index: true, null:false

      t.timestamps
    end
  end
end
