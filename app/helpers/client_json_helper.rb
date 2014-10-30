module ClientJsonHelper

  def member_location_from_hunting_mode_location(hunting_mode_user_location)
    member_location = {
      user_id: hunting_mode_user_location.user_id,
      user_name: hunting_mode_user_location.user.get_display_name,
      location_id: hunting_mode_user_location.hunting_location_id.nil? ? '' : hunting_mode_user_location.hunting_location_id,
      location_name: hunting_mode_user_location.hunting_location_id.nil? ? '' : hunting_mode_user_location.hunting_location.name
    }
    if hunting_mode_user_location.location_coordinates.nil?
      unless hunting_mode_user_location.hunting_location_id.nil?
        member_location[:location_coordinates] = {
          lat: hunting_mode_user_location.hunting_location.coordinates.y(),
          lng: hunting_mode_user_location.hunting_location.coordinates.x()
        }
      end
    else
      member_location[:location_coordinates] = {
        lat: hunting_mode_user_location.location_coordinates.y(),
        lng: hunting_mode_user_location.location_coordinates.x()
      }
    end
    member_location

  end

  def stand_reservation_from_hunting_location_schedule(hunting_location_schedule)
    {
      id: hunting_location_schedule.id,
      location_id: hunting_location_schedule.hunting_location_id,
      created_by_id: hunting_location_schedule.created_by_id,
      created_by: hunting_location_schedule.created_by.get_display_name,
      start_date_time: hunting_location_schedule.start_date_time,
      end_date_time: hunting_location_schedule.end_date_time
    }
  end

  def hunting_location_to_stand_location(hunting_location)
    {
      id: hunting_location.id,
      name: hunting_location.name,
      coordinates: {
        lat: hunting_location.coordinates.y(),
        lng: hunting_location.coordinates.x()
      }
    }
  end

end
