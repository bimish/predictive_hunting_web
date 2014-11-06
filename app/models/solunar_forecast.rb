class SolunarForecast < ActiveRecord::Base

  validates :location_id, presence: true
  validates :forecast_day, presence: true
  validates :sun_rise, presence: true
  validates :sun_set, presence: true
  validates :activity_indicator, presence: true
  validates :moon_phase, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :activity_indicator, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  belongs_to :solunar_forecast_location

  def self.for_month(forecast_location_id, month = Date.today)
    where(location_id: forecast_location_id).where('forecast_day between ? and ?', month.at_beginning_of_month, month.at_end_of_month)
  end

end
