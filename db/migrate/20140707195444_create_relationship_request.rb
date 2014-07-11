class CreateRelationshipRequest < ActiveRecord::Migration
  def change
    create_table :relationship_request do |t|
      t.references :created_by, references: :user, index: true, null: false
      t.references :related_user, references: :user, index: true, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
