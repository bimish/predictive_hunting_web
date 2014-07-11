class HuntingPlot < ActiveRecord::Base

  set_rgeo_factory_for_column(:location_coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))
  set_rgeo_factory_for_column(:boundary, RGeo::Geos.factory(:srid => 4326))

  validates :name, presence: true, length: { maximum: 100 }

  has_many :locations, :class_name => 'HuntingLocation'
  has_many :named_animals, :class_name => 'HuntingPlotNamedAnimal'
  has_many :user_accesses, :class_name => 'UserHuntingPlotAccess'
  has_many :users, through: :user_accesses, :class_name => 'User'

  def get_display_name
    self.name
  end

end
