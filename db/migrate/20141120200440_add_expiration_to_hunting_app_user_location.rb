class AddExpirationToHuntingAppUserLocation < ActiveRecord::Migration
  def change
    add_column :hunting_mode_user_location, :expires_at, :datetime
  end
end
