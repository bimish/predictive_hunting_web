class CreateUserGroup < ActiveRecord::Migration
  def change
    create_table :user_group do |t|
      t.string :name, limit: 100, null:false
      t.integer :group_type, limit: 2, null:false
      t.references :hunting_plot

      t.timestamps
    end
  end
end
