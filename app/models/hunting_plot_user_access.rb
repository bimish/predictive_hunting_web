class HuntingPlotUserAccess < ActiveRecord::Base

  validates :user_id, presence: true
  validates :hunting_plot_id, presence: true, uniqueness: { :scope => :user_id }

  belongs_to :user
  belongs_to :hunting_plot

  controller_assigned_attribute :hunting_plot_id
  write_once_attribute :user_id, :hunting_plot_id

  def self.permissions_flags
    @@permissions_flags ||= { 0 => :administrate, 1 => :manage_locations, 2 => :manage_members, 3 => :manage_named_animals, 4 => :manage_schedules }
  end

  is_flags :permissions, HuntingPlotUserAccess.permissions_flags, flag_prefix: 'can'

  def self.can_administrate?(hunting_plot_id, user_id)
    user_access = HuntingPlotUserAccess.find_by(hunting_plot_id: hunting_plot_id, user_id: user_id)
    !user_access.nil? && user_access.permissions_can_administrate?
  end

  def self.can_manage_members?(hunting_plot_id, user_id)
    user_access = HuntingPlotUserAccess.find_by(hunting_plot_id: hunting_plot_id, user_id: user_id)
    !user_access.nil? && (user_access.permissions_can_administrate? || user_access.permissions_can_manage_users?)
  end

  def self.can_manage_locations?(hunting_plot_id, user_id)
    user_access = HuntingPlotUserAccess.find_by(hunting_plot_id: hunting_plot_id, user_id: user_id)
    !user_access.nil? && (user_access.permissions_can_administrate? || user_access.permissions_can_manage_locations?)
  end

  def self.can_manage_named_animals?(hunting_plot_id, user_id)
    user_access = HuntingPlotUserAccess.find_by(hunting_plot_id: hunting_plot_id, user_id: user_id)
    !user_access.nil? && (user_access.permissions_can_administrate? || user_access.permissions_can_manage_named_animals?)
  end

  def self.can_manage_schedules?(hunting_plot_id, user_id)
    user_access = HuntingPlotUserAccess.find_by(hunting_plot_id: hunting_plot_id, user_id: user_id)
    !user_access.nil? && (user_access.permissions_can_administrate? || user_access.permissions_can_manage_schedules?)
  end

  def can_manage?
    self.permissions > 0
  end

  def self.can_access?(hunting_plot_id, user_id)
    user_access = HuntingPlotUserAccess.find_by(hunting_plot_id: hunting_plot_id, user_id: user_id)
    !user_access.nil?
  end

  def authorize_action?(user, crud_action)
    case crud_action
      when :create, :update, :delete
        # users can manage themselves or other users if they have the manage users permission
        self.user_id == user.id || HuntingPlotUserAccess.can_manage_members?(self.hunting_plot_id, user.id)
      when :read
        # members of a hunting plot can see other members
        HuntingPlotUserAccess.exists?(hunting_plot_id: self.hunting_plot_id, user_id: user.id)
      else
        raise ArgumentError, "The specified action (#{crud_action}) is not supported"
    end
  end

end
