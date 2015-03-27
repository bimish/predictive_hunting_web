module HuntingLocationSchedulesHelper
  def self.index_default_attribute_list(vantage_point = nil)
    case
    when :location
      [ :created_by_id, :start_date_time, :end_date_time, :entry_type, :time_period ]
    when :created_by
      [ :hunting_location_id, :start_date_time, :end_date_time, :entry_type, :time_period ]
    else
      [ :hunting_location_id, :created_by_id, :start_date_time, :end_date_time, :entry_type, :time_period ]
    end
  end
end
