class CreateUserHuntingPlotAccess < ActiveRecord::Migration
  def change
    create_table :user_hunting_plot_access do |t|
      t.references :user, index: true, null: false
      t.references :hunting_plot, index: true, null: false
      t.string :alias, limit: 100, null: true
      t.integer :permissions, default: 1

      t.timestamps
    end
    add_index :user_hunting_plot_access, [:user_id, :hunting_plot_id], :unique => true
  end
end
