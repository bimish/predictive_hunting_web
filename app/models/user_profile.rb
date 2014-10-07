class UserProfile

  include ActiveModel::Validations

  attr_accessor :age_range
  attr_accessor :gender
  attr_accessor :type_of_hunting
  attr_accessor :hunting_frequency
  attr_accessor :use_cameras
  attr_accessor :use_feeders
  attr_accessor :hunting_station_type
  attr_accessor :weapon_type
  attr_accessor :outdoor_activities
  attr_accessor :plot_type

  def initialize(user)
    @age_range = get_item_value(user.profile_item_values, @@profile_item_ids[:age_range])
  end

  def save

  end

private
  def get_item_value(item_values, item_id)
    item_values = item_values.select { |item_value| item_value.id == item_id }
    if item_values.nil? || (item_values.length == 0)
      nil
    else
      item_values.collect { |item_value| item_value.value }
    end
  end

  # get the item ids from the database table
  def self.get_item_id(profile_items, item_name)
    profile_items.detect { |profile_item| profile_item.name == item_name }
  end
  def self.initialize_profile_item_ids
    profile_items = UserProfileItem.all
    @@profile_item_ids =
    {
      'age_range' => get_item_id(profile_items, 'ageRange'),
      'gender' => get_item_id(profile_items, 'gender'),
      'type_of_hunting' => get_item_id(profile_items, 'typeOfHunting'),
      'hunting_frequency' => get_item_id(profile_items, 'huntingFrequency'),
      'use_cameras' => get_item_id(profile_items, 'useCameras'),
      'use_feeders' => get_item_id(profile_items, 'useFeeders'),
      'hunting_station_type' => get_item_id(profile_items, 'huntingStationType'),
      'weapon_type' => get_item_id(profile_items, 'weaponType'),
      'outdoor_activities' => get_item_id(profile_items, 'outdoorActivities'),
      'plot_type' => get_item_id(profile_items, 'plotType')
    }
  end
  initialize_profile_item_ids

end
