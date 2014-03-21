class HuntingPlot < ActiveRecord::Base

	set_rgeo_factory_for_column(:location_coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))
	set_rgeo_factory_for_column(:boundary, RGeo::Geographic.spherical_factory(:srid => 4326))

	has_many :hunting_locations

end
