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
  has_many :temporary_user_accesses, class_name:'HuntingLocationTemporaryAccess'

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

  def can_checkin?(user, starting_at = nil, ending_at = nil)
    if HuntingPlotUserAccess.can_access?(self.hunting_plot_id, user.id)
      return true if self.access_flags_public?
      return true if self.user_accesses.exists?(user_id: user.id)
      return true if self.user_group_accesses.joins(:user_group).joins(user_group: :members).where(user_group_member: { user_id: user.id }).exists?
      unless starting_at.nil? || ending_at.nil?
        return true if self.temporary_user_accesses.where('starts_at <= ?', starting_at).where('ends_at >= ?', ending_at).where(user_id: user.id).exists?
      end
    end
    false
  end

  def set_user_access(user_ids)
    if (user_ids.nil?)
      self.user_accesses.destroy_all
    else
      existing_user_ids = self.user_accesses.pluck(:user_id)
      ActiveRecord::Base.transaction do
        user_ids.each do |user_id|
          unless existing_user_ids.include?(user_id)
            self.user_accesses.create!(user_id: user_id)
          end
        end
        existing_user_ids.each do |user_id|
          unless user_ids.include?(user_id)
            self.user_accesses.find_by(user_id: user_id).destroy
          end
        end
      end
    end
  end

  def set_user_group_access(user_group_ids)
    if (user_group_ids.nil?)
      self.user_group_accesses.destroy_all
    else
      existing_user_group_ids = self.user_group_accesses.pluck(:user_group_id)
      ActiveRecord::Base.transaction do
        user_group_ids.each do |user_group_id|
          unless existing_user_group_ids.include?(user_group_id)
            self.user_group_accesses.create!(user_group_id: user_group_id)
          end
        end
        existing_user_group_ids.each do |user_group_id|
          unless user_group_ids.include?(user_group_id)
            self.user_group_accesses.find_by(user_group_id: user_group_id).destroy
          end
        end
      end
    end
  end

end
