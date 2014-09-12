json.array!(@hunting_location_schedules) do |hunting_location_schedule|
  json.extract! hunting_location_schedule, :id, :created_by_id, :hunting_location_id, :start_date_time, :end_date_time, :entry_type, :created_at, :updated_at
  json.url hunting_location_schedule_url(hunting_location_schedule, format: :json)
end
