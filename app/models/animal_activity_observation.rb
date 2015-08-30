class AnimalActivityObservation < ActiveRecord::Base

  validates :hunting_plot_id, :presence => true
  validates :hunting_location_id, :presence => false
  validates :animal_category_id, :presence => false
  validates :animal_count, :presence => true, numericality: { only_integer: true, greater_than: 0 }
  validates :animal_activity_type_id, :presence => true
  #validates :hunting_plot_named_animal
  validates :observation_date_time, :presence => true

  validates :location_coordinates, presence:true, if: ->(record) { record.hunting_location_id.nil?  }

  belongs_to :hunting_plot
  belongs_to :hunting_location
  belongs_to :animal_category
  belongs_to :animal_activity_type
  belongs_to :named_animal, class_name:'HuntingPlotNamedAnimal', foreign_key:'hunting_plot_named_animal_id'
  belongs_to :created_by, class_name:'User'

  controller_assigned_attribute :hunting_plot_id, :location_coordinates
  component_assigned_attribute :created_by_id

  def authorize_action?(user, action)
    case action
    when :create, :read
      true
    when :update, :destroy
      self.created_by_id == user.id
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

  def init_new(signed_in_user)
    super
    self.created_by_id = signed_in_user.id unless signed_in_user.nil?
    self.animal_count = 1 if self.animal_count.nil?
  end

  def self.search(hunting_plot_id, search_criteria = { })
    if (hunting_plot_id.nil?)
      raise ArgumentError, 'hunting_plot_id cannot be nil'
    end
    search_results = where(hunting_plot_id: hunting_plot_id)
    if (!search_criteria[:hunting_location_id].blank?)
      search_results = search_results.where(hunting_location_id: search_criteria[:hunting_location_id])
    end
    if (!search_criteria[:hunting_plot_named_animal_id].blank?)
      search_results = search_results.where(hunting_plot_named_animal_id: search_criteria[:hunting_plot_named_animal_id])
    end
    if (!search_criteria[:animal_category_id].blank?)
      search_results = search_results.where(animal_category_id: search_criteria[:animal_category_id])
    end
    if (!search_criteria[:animal_activity_type_id].blank?)
      search_results = search_results.where(animal_activity_type_id: search_criteria[:animal_activity_type_id])
    end
    if (!search_criteria[:after_date].blank?)
      search_results = search_results.where('observation_date_time >= ?', search_criteria[:after_date])
    end
    if (!search_criteria[:before_date].blank?)
      search_results = search_results.where('observation_date_time <= ?', search_criteria[:before_date])
    end
    search_results
  end

private

end
