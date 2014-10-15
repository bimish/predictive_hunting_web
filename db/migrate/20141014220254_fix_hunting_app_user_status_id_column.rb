class FixHuntingAppUserStatusIdColumn < ActiveRecord::Migration
  def change
    rename_column :hunting_mode_user_status, :status_id, :status_type
  end
end
