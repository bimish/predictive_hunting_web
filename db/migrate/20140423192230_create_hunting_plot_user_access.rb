class CreateHuntingPlotUserAccess < ActiveRecord::Migration
  def change
    create_table :hunting_plot_user_access do |t|
      t.references :user, index: true, null: false
      t.references :hunting_plot, index: true, null: false
      t.string :alias, limit: 100, null: true
      t.integer :permissions, default: 0

      t.timestamps
    end
    add_index :hunting_plot_user_access, [:user_id, :hunting_plot_id], :unique => true
  end
end
