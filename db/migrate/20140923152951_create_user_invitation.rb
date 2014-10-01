class CreateUserInvitation < ActiveRecord::Migration
  def change
    create_table :user_invitation do |t|
      t.string :email, null: false, limit: 254, index: true
      t.references :created_by, references: :user, null: false
      t.string :message, null: true, limit: 1000
      t.integer :status, limit: 2, null: false
      t.timestamps
    end
  end
end
