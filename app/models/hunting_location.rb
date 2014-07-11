class HuntingLocation < ActiveRecord::Base

  set_rgeo_factory_for_column(:coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  validates :name, presence:true, length: { maximum: 100 }
  validates :location_type, presence: true
  #validates :name, presence => true, :uniqueness => { :scope => :hunting_plot_id }

  enum location_type: { location_type_stand: 1, location_type_camera: 2, location_type_feed: 3 }

  belongs_to :hunting_plot

  write_once_attribute :hunting_plot_id
  controller_assigned_attribute :hunting_plot_id

  def get_display_name
    self.name
  end

end
