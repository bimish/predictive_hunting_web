class CreateHuntingPlotUserAccessRequest < ActiveRecord::Migration
  def change
    create_table :hunting_plot_user_access_request do |t|
      t.references :user, null: true, index: true
      t.references :user_invitation, null: true, index: true
      t.references :hunting_plot, null: false
      t.string :message, null: true, limit: 1000
      t.string :alias, limit: 100, null: true
      t.integer :initial_permissions
      t.references :created_by_user, references: :user, null: false
      t.timestamps
    end
  end
end
