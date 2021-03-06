class CreateUser < ActiveRecord::Migration
  def change
    create_table :user do |t|
      t.string  :first_name,            null: false, limit: 100
      t.string  :last_name,             null: false, limit: 100
      t.string  :alias,                 null: true,  limit: 100
      t.string  :email,                 null: false, limit: 254
      t.string  :password_digest,       null: false
      t.string  :remember_token
      t.integer :authentication_method, null: false, default: 1
      t.boolean  :admin,                null: false, default: false

      t.timestamps
    end
  end
end
