module ClientJsonHelper

  def member_location_from_hunting_mode_location(hunting_mode_user_location)
    member_location = {
      user_id: hunting_mode_user_location.user_id,
      user_name: hunting_mode_user_location.user.get_display_name,
      location_id: hunting_mode_user_location.hunting_location_id.nil? ? '' : hunting_mode_user_location.hunting_location_id,
      location_name: hunting_mode_user_location.hunting_location_id.nil? ? '' : hunting_mode_user_location.hunting_location.name
    }
    if hunting_mode_user_location.hunting_location_id.nil?
      unless hunting_mode_user_location.location_coordinates.nil?
        member_location[:location_coordinates] = {
          lat: hunting_mode_user_location.location_coordinates.y(),
          lng: hunting_mode_user_location.location_coordinates.x()
        }
      end
    else
      member_location[:location_coordinates] = {
        lat: hunting_mode_user_location.hunting_location.coordinates.y(),
        lng: hunting_mode_user_location.hunting_location.coordinates.x()
      }
    end
    member_location

  end

end
