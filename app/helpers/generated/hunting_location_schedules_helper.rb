module Generated
  module HuntingLocationSchedulesHelper
    def get_created_by_description(hunting_location_schedule)
      return hunting_location_schedule.created_by.get_display_name
    end
    def get_hunting_location_description(hunting_location_schedule)
      return hunting_location_schedule.hunting_location.get_display_name
    end
  end
end
