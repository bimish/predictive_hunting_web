class CreateUserPost < ActiveRecord::Migration
  def change
    create_table :user_post do |t|
      t.references :created_by, references: :user, index: true, null: false
      t.string :post_content, limit: 1000, null: false
      t.integer :visibility, null: false

      t.timestamps
    end
  end
end
