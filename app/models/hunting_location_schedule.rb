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

  def self.current_schedules_for_plot(hunting_plot, window_size = 12)
    search_results = HuntingLocationSchedule.joins(:hunting_location).where(hunting_location:{ hunting_plot_id: hunting_plot.id })
    start_date_time = DateTime.now
    end_date_time = window_size.hours.from_now
    search_results = where('((start_date_time BETWEEN ? AND ?) OR (end_date_time BETWEEN ? AND ?) OR (start_date_time < ? AND end_date_time > ?))', start_date_time, end_date_time, start_date_time, end_date_time, start_date_time, end_date_time)
    search_results
  end

end
