class SolunarForecast < ActiveRecord::Base

  validates :location_id, presence: true
  validates :forecast_day, presence: true
  validates :sun_rise, presence: true
  validates :sun_set, presence: true
  validates :activity_indicator, presence: true
  validates :moon_phase, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :activity_indicator, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  belongs_to :location, class_name: 'SolunarForecastLocation'

  def self.for_month(forecast_location_id, month = Date.today)
    where(location_id: forecast_location_id).where('forecast_day between ? and ?', month.at_beginning_of_month, month.at_end_of_month)
  end

  def sun_rise
    @corrected_sun_rise ||= corrected_time(self[:sun_rise])
  end

  def sun_set
    @corrected_sun_set ||= corrected_time(self[:sun_set])
  end

  def moon_rise
    @corrected_moon_rise ||= corrected_time(self[:moon_rise])
  end

  def moon_set
    @corrected_moon_set ||= corrected_time(self[:moon_set])
  end

  def moon_up
    @corrected_moon_up ||= corrected_time(self[:moon_up])
  end

  def moon_down
    @corrected_moon_down ||= corrected_time(self[:moon_down])
  end

  def minor_am
    @corrected_minor_am ||= corrected_time(self[:minor_am])
  end

  def minor_pm
    @corrected_minor_pm ||= corrected_time(self[:minor_pm])
  end

  def major_am
    @corrected_major_am ||= corrected_time(self[:major_am])
  end

  def major_pm
    @corrected_major_pm ||= corrected_time(self[:major_pm])
  end

private
  def corrected_time(time)
    @forecast_date ||= self.forecast_day.to_datetime
    @forecast_date.change(hour: time.hour, min: time.min, offset: time_zone_offset).in_time_zone
  end
  def time_zone_offset
    @time_zone_offset ||= ActiveSupport::TimeZone.new(self.location.time_zone).at(self.forecast_day.to_datetime.midday).formatted_offset
  end

end
