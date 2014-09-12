class HuntingPlot < ActiveRecord::Base

  set_rgeo_factory_for_column(:location_coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))
  set_rgeo_factory_for_column(:boundary, RGeo::Geos.factory(:srid => 4326))

  validates :name, presence: true, length: { maximum: 100 }

  has_many :locations, :class_name => 'HuntingLocation'
  has_many :named_animals, :class_name => 'HuntingPlotNamedAnimal'
  has_many :user_accesses, :class_name => 'HuntingPlotUserAccess'
  has_many :users, through: :user_accesses, :class_name => 'User'

  def get_display_name
    self.name
  end

  def authorize_action?(user, action)
    case action
    when :read
      HuntingPlotUserAccess.can_access? self.id, user.id
    when :create, :destroy
      user.admin?
    when :update
      HuntingPlotUserAccess.can_administrate? self.id, user.id
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

end
