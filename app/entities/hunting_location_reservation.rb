require "app/date_time_helpers"

class HuntingLocationReservation <  HuntingLocationSchedule

  attr_reader :reservation_date, :start_time, :end_time
  #attr_accessor :reservation_date, :start_time, :end_time
  #attr_accessor :start_time, :end_time

  def created_by_name
    created_by_id.nil? ? nil : created_by.get_display_name
  end

  after_initialize do
    if new_record?
      self.entry_type = :entry_type_reservation
    end
    unless self.start_date_time.nil?
      @reservation_date = self.start_date_time.to_date
    end
  end

  after_find do
    if (self.time_period_custom?)
      @start_time = self.start_date_time.to_time
      @end_time = self.end_date_time.to_time
    end
  end

  def reservation_date=(value)
    @reservation_date = ActiveRecord::ConnectionAdapters::Column.value_to_date(value)
  end

  def start_time=(value)
    @start_time = Time.parse(value)
  end

  def end_time=(value)
    @end_time = Time.parse(value)
  end

  def on_begin_save
    unless @reservation_date.nil?
      self.start_date_time = @reservation_date
      self.end_date_time = @reservation_date
      if (self.time_period_custom?)
        if @start_time.nil?
          errors.add(:start_date_time, "A start time must be provided if time period is set to custom")
        else
          self.start_date_time = DateTimeHelpers.set_time_part(self.start_date_time, @start_time)
        end
        if @end_time.nil?
          errors.add(:end_date_time, "An end time must be provided if time period is set to custom")
        else
          self.end_date_time = DateTimeHelpers.set_time_part(self.end_date_time, @end_time)
        end
      end
    end
    super
  end

  def self.search(hunting_plot_id, params)
    if params[:hunting_location_id].blank?
      search_results = joins(:hunting_location).where(hunting_location:{ hunting_plot_id: hunting_plot_id })
    else
      search_results = where(hunting_location_id: params[:hunting_location_id])
    end
    unless params[:reservation_date].blank?
      reservation_date = DateTime.parse(params[:reservation_date])
      start_date = reservation_date.beginning_of_day
      end_date = reservation_date.end_of_day
      case params[:reservation_date_operator]
        when 'equals'
          search_results = search_results.where('start_date_time >= ? and start_date_time <= ?', start_date, end_date)
        when 'after'
          search_results = search_results.where('start_date_time >= ?', start_date)
        when 'before'
          search_results = search_results.where('start_date_time <= ?', end_date)
      end
    end
    unless params[:created_by_user_id].blank?
      search_results = search_results.where(created_by_id: params[:created_by_user_id])
    end
    search_results
  end

end
