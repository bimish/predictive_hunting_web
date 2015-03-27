class RemoveHuntingLocationScheduleDefaultTimePeriod < ActiveRecord::Migration
  def up
    change_column_default :hunting_location_schedule, :time_period, nil
  end
  def down
    change_column_default :hunting_location_schedule, :time_period, 1
  end
end
