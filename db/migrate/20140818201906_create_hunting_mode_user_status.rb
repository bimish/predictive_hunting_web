class CreateHuntingModeUserStatus < ActiveRecord::Migration
  def change
    create_table :hunting_mode_user_status do |t|
      t.references :user, index: true, null: false
      t.references :hunting_plot, index: true, null: false
      t.integer :status_id, null: false
      t.string :status_text, null: false, limit: 1000
      t.timestamps
    end
  end
end
