class HuntingLocationSchedule < ActiveRecord::Base

  validates :created_by_id, :presence => true
  validates :hunting_location_id, :presence => true
  validates :start_date_time, :presence => true
  validates :end_date_time, :presence => true

  belongs_to :created_by, class_name:'User'
  belongs_to :hunting_location

  enum entry_type: { entry_type_reservation: 1 }

  controller_assigned_attribute :hunting_location_id
  component_assigned_attribute :created_by_id

  def authorize_action?(user, action)
    case action
    when :read, :create
      HuntingPlotUserAccess.can_access?(self.hunting_location.hunting_plot_id, user.id)
    when :update, :delete
      self.created_by_id == user.id || HuntingPlotUserAccess.can_manage_schedules?(self.hunting_location.hunting_plot_id, user.id)
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

  def init_new(signed_in_user)
    super
    self.created_by_id = signed_in_user.id
  end

end
