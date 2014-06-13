class HuntingLocation < ActiveRecord::Base

  set_rgeo_factory_for_column(:coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  validates :location_type,
    presence: true,
    :inclusion => { :in => DataDomains::HuntingLocationTypes.values }
  #validates :name, presence => true, :uniqueness => { :scope => :hunting_plot_id }

  belongs_to :hunting_plot

end
