class UserNetworkBoundary < ActiveRecord::Base

  set_rgeo_factory_for_column(:boundary, RGeo::Geos.factory(:srid => 4326))

  validates :user_network_id, presence: true
  #validates :boundary, presence: true
  belongs_to :user_network

end
