class AddAccessTypeToHuntingLocation < ActiveRecord::Migration
  def change
    add_column :hunting_location, :access_flags, :int, default: 1, null: false
  end
end
