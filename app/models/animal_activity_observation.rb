class AnimalActivityObservation < ActiveRecord::Base

  validates :hunting_location_id, :presence => true
  validates :animal_category_id, :presence => false
  validates :animal_count, :presence => true, numericality: { only_integer: true, greater_than: 0 }
  validates :animal_activity_type_id, :presence => true
  #validates :hunting_plot_named_animal
  validates :observation_date_time, :presence => true

  belongs_to :hunting_location
  belongs_to :animal_category
  belongs_to :animal_activity_type
  belongs_to :hunting_plot_named_animal
end
