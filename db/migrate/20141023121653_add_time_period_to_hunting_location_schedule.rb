class AddTimePeriodToHuntingLocationSchedule < ActiveRecord::Migration
  def change
    add_column :hunting_location_schedule, :time_period, :integer, limit: 2, null: false, default: 1
  end
end
