class AddPasswordResetToUser < ActiveRecord::Migration
  def change
    add_column :user, :password_reset_token, :string
    add_column :user, :password_reset_sent_at, :datetime
  end
end
