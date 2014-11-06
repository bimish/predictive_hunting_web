class SolunarForecastLocation < ActiveRecord::Base

  set_rgeo_factory_for_column(:location_coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  validates :name, presence:true, length: { maximum: 100 }

  def self.nearest_to_plot(hunting_plot)
    order("ST_Distance(solunar_forecast_location.location_coordinates, ST_GeographyFromText('#{hunting_plot.location_coordinates.as_text}'))").limit(1).first
  end

end
