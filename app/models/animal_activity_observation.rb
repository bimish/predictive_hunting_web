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
  belongs_to :named_animal, class_name:'HuntingPlotNamedAnimal', foreign_key:'hunting_plot_named_animal_id'
  belongs_to :created_by, class_name:'User'
  has_one :hunting_plot, :through => :hunting_location

  component_assigned_attribute :created_by_id
  set_new_record_initializer :new_record_init

private
  def new_record_init(signed_in_user)
    self.created_by_id = signed_in_user.id unless signed_in_user.nil?
  end

end
