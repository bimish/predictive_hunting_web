class SolunarForecastLocation < ActiveRecord::Base

  validates :name, presence:true, length: { maximum: 100 }

  def self.nearest_to_plot(hunting_plot)
    order("ST_Distance(solunar_forecast_location.location_coordinates, ST_GeographyFromText('#{hunting_plot.location_coordinates.as_text}'))").limit(1).first
  end

end
