class HuntingPlotUserAccess < ActiveRecord::Base

  belongs_to :user
  belongs_to :hunting_plot

  controller_assigned_attribute :hunting_plot_id
  write_once_attribute :user_id, :hunting_plot_id

  is_flags :permissions, { 0 => :administrate, 1 => :manage_locations, 2 => :manage_members }, flag_prefix: 'can'

  def self.can_manage_users?(hunting_plot_id, user_id)
    user_access = HuntingPlotUserAccess.find_by(hunting_plot_id: hunting_plot_id, user_id: user_id)
    !user_access.nil? && (user_access.permissions_can_administrate? || user_access.permissions_can_manage_users?)
  end

  def authorize_action?(user, crud_action)
    case crud_action
      when :create, :update, :delete
        # users can manage themselves or other users if they have the manage users permission
        self.user_id == user.id || HuntingPlotUserAccess.can_manage_users?(self.hunting_plot_id, user.id)
      when :read
        # members of a hunting plot can see other members
        HuntingPlotUserAccess.exists?(hunting_plot_id: self.hunting_plot_id, user_id: user.id)
      else
        raise ArgumentError, "The specified action (#{crud_action}) is not supported"
    end
  end

end