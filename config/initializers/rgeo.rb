RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|

  #config.default = RGeo::Geographic.spherical_factory(srid: 4326)

  # By default, use the GEOS implementation for spatial columns.
  config.default = RGeo::Geos.factory_generator

  # But use a geographic implementation for point columns.
  config.register(RGeo::Geographic.spherical_factory(srid: 4326), geo_type: "point")

  #set_rgeo_factory_for_column(:location_coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))
  #set_rgeo_factory_for_column(:boundary, RGeo::Geos.factory(:srid => 4326))

end
