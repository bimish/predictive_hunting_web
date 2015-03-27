module HuntingLocationsHelper
  def self.get_access_flags_description(hunting_location)
    enabled_flags = Array.new
    if (hunting_location.public?)
      enabled_flags.push 'Public'
    end
    if (hunting_location.accepts_requests?)
      enabled_flags.push 'Accepts Requests'
    end
    enabled_flags.join(', ')
  end
  def self.index_attribute_list(vantage_point = nil)
    case vantage_point
    when :schedules
      [ :name ]
    when :access
      [ :name, :access_flags ]
    else
      [ :name, :location_type ]
    end
  end
  def self.index_command_list(vantage_point = nil)
    case vantage_point
    when :schedule
      [ :schedule ]
    when :access
      [ :acess ]
    else
      [ :edit, :delete ]
    end
  end
end
