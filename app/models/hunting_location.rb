class HuntingLocation < ActiveRecord::Base

  set_rgeo_factory_for_column(:coordinates, RGeo::Geographic.spherical_factory(:srid => 4326))

  validates :name, presence:true, length: { maximum: 100 }
  validates :location_type, presence: true
  validates :coordinates, presence: true
  #validates :name, presence => true, :uniqueness => { :scope => :hunting_plot_id }

  enum location_type: { location_type_stand: 1, location_type_camera: 2, location_type_feed: 3 }

  def self.access_flags
    @@access_flags ||= { 0 => :public, 1 => :accepts_requests }
  end
  is_flags :access_flags, HuntingLocation.access_flags

  # relationships
  belongs_to :hunting_plot
  has_many :schedules, class_name:'HuntingLocationSchedule'
  has_many :user_accesses, class_name:'HuntingLocationUserAccess'
  has_many :user_group_accesses, class_name:'HuntingLocationUserGroupAccess'

  write_once_attribute :hunting_plot_id
  controller_assigned_attribute :hunting_plot_id

  def get_display_name
    self.name
  end

  def init_new(signed_in_user)
    super
    if self.coordinates.nil? && !self.hunting_plot.nil?
      self.coordinates = self.hunting_plot.location_coordinates
    end
  end

  def authorize_action?(user, action)
    case action
    when :read, :create
      HuntingPlotUserAccess.can_access?(self.hunting_plot_id, user.id)
    when :update, :delete
      HuntingPlotUserAccess.can_manage_locations?(self.hunting_plot_id, user.id)
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

end
