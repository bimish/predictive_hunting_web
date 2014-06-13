class CreateUserRelationship < ActiveRecord::Migration
  def change
    create_table :user_relationship do |t|
      t.references :owning_user, references: :user, null: false
      t.references :related_user, references: :user, null: false
      t.integer :relationship_type, :limit => 2, null: false
      t.timestamps
    end
    add_index :user_relationship, [ :owning_user_id, :related_user_id ], :unique => true
  end
end
