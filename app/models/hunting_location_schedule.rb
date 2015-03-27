class HuntingLocationSchedule < ActiveRecord::Base

  validates :created_by_id, :presence => true
  validates :hunting_location_id, :presence => true
  validates :start_date_time, :presence => true
  validates :end_date_time, :presence => true
  validate :check_uniqueness, :if => :validate_uniqueness?

  belongs_to :created_by, class_name:'User'
  belongs_to :hunting_location

  enum entry_type: { entry_type_reservation: 1 }
  attr_reader :entry_type

  def self.TIME_PERIODS
    @@TIME_PERIODS ||= { time_period_custom: 1, time_period_am: 2, time_period_pm: 3, time_period_all_day: 4 }
  end
  enum time_period: HuntingLocationSchedule.TIME_PERIODS

  controller_assigned_attribute :hunting_location_id
  component_assigned_attribute :created_by_id

  before_validation :on_begin_save
  #before_save :before_save_handler

  def authorize_action?(user, action)
    case action
    when :create
      # can't authorize create until a location is selected
      self.hunting_location_id.nil? ||  HuntingPlotUserAccess.can_access?(self.hunting_location.hunting_plot_id, user.id)
    when :read
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
    find_by_location_and_date_range hunting_location.id, start_date_time, end_date_time
  end

  def self.next_reservation(location_id)
    where(hunting_location_id: location_id).where('end_date_time > ?', Time.now).order(start_date_time: :asc).limit(1).first
  end

protected
  def validate_uniqueness?
    !errors[:start_date_time].any? && !errors[:end_date_time].any?
  end
  def on_begin_save
    set_time_periods
  end

private
  def set_time_periods
    puts 'before save in HuntingLocationSchedule'
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

  def self.find_by_location_and_date_range(location_id, start_date_time, end_date_time)
    search_results = where(hunting_location_id: location_id)
    search_results = search_results.where('((start_date_time BETWEEN ? AND ?) OR (end_date_time BETWEEN ? AND ?) OR (start_date_time < ? AND end_date_time > ?))', start_date_time, end_date_time, start_date_time, end_date_time, start_date_time, end_date_time)
    search_results
  end

  def check_uniqueness
    #ensure there are not other records for the same location, date and time
    existing_records = HuntingLocationSchedule.find_by_location_and_date_range(self.hunting_location_id, self.start_date_time, self.end_date_time)

    is_overlap = false
    if existing_records.size() > 0
      if (self.new_record?)
        is_overlap = true
      else
        if (existing_records.size() > 1) || (existing_records.first.id != self.id)
          is_overlap = true
        end
      end
    end

    if is_overlap
      errors.add(:base, "Another record already exists for this location, date and time period")
    end
  end

end
