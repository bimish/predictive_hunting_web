class HuntingModeUserLocation < ActiveRecord::Base

  belongs_to :user
  belongs_to :hunting_plot
  set_rgeo_factory_for_column(:location_coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  component_assigned_attribute :created_by_id

end
