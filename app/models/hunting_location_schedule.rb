class HuntingLocationSchedule < ActiveRecord::Base

  validates :created_by_id, :presence => true
  validates :hunting_location_id, :presence => true
  validates :start_date_time, :presence => true
  validates :end_date_time, :presence => true

  belongs_to :created_by, class_name:'User'
  belongs_to :hunting_location

  enum entry_type: { entry_type_reservation: 1 }
  enum time_period: { time_period_custom: 1, time_period_am: 2, time_period_pm: 3, time_period_all_day: 4 }

  controller_assigned_attribute :hunting_location_id
  component_assigned_attribute :created_by_id

  before_save :set_time_period

  def reservation_date
    @start_date_time.to_date
  end
  def reservation_date=(value)
    set_date_part @start_date_time, value.to_date
    set_date_part @end_date_time, value.to_date
  end

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

  def self.schedules_for_plot(hunting_plot, start_date_time = DateTime.now, end_date_time = 12.hours.from_now)
    search_results = joins(:hunting_location).where(hunting_location:{ hunting_plot_id: hunting_plot.id })
    search_results = search_results.where('((start_date_time BETWEEN ? AND ?) OR (end_date_time BETWEEN ? AND ?) OR (start_date_time < ? AND end_date_time > ?))', start_date_time, end_date_time, start_date_time, end_date_time, start_date_time, end_date_time)
    search_results
  end

  def self.schedules_for_location(hunting_location, start_date_time = Date.today.beginning_of_day, end_date_time = nil)
    if (end_date_time.nil?)
      end_date_time = start_date_time.end_of_day
    end
    search_results = where(hunting_location_id: hunting_location.id)
    search_results = search_results.where('((start_date_time BETWEEN ? AND ?) OR (end_date_time BETWEEN ? AND ?) OR (start_date_time < ? AND end_date_time > ?))', start_date_time, end_date_time, start_date_time, end_date_time, start_date_time, end_date_time)
    search_results
  end

  def self.next_reservation(location_id)
    where(hunting_location_id: location_id).where('end_date_time > ?', Time.now).order(start_date_time: :asc).limit(1).first
  end

private
  def set_time_period
    if self.time_period_am?
      self.start_date_time = self.start_date_time.beginning_of_day
      self.end_date_time = (self.start_date_time.middle_of_day - 1.hours).end_of_hour
    elsif self.time_period_pm?
      self.start_date_time = self.start_date_time.middle_of_day
      self.end_date_time = self.start_date_time.end_of_day
    elsif self.time_period_all_day?
      self.start_date_time = self.start_date_time.beginning_of_day
      self.end_date_time = self.start_date_time.end_of_day
    end
  end
  def set_date_part(date_time_value, new_date)
    date_time_value.change(:year => new_date.year, :month => new_date.month, :day => new_date.day)
  end
  def set_time_part(date_time_value, new_time)
    date_time_value.change(:hour => new_time.hour, :minute => new_time.minute, :second => new_time.second)
  end

end
