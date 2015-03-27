class HuntingLocationUserGroupAccess < ActiveRecord::Base

  validates :hunting_location_id, presence:true
  validates :user_group_id, presence:true
  belongs_to :hunting_location
  belongs_to :user_group

  controller_assigned_attribute :hunting_location_id
  write_once_attribute :user_group_id

  def get_display_name
    "#{self.hunting_location.get_display_name} - #{self.user_group.get_display_name}"
  end

  def init_new(signed_in_user)
    super
  end

  def authorize_action?(user, action)
    case action
    when :read
      HuntingPlotUserAccess.can_access?(self.hunting_location.hunting_plot_id, user.id)
    when :create, :update, :delete
      HuntingPlotUserAccess.can_manage_locations?(self.hunting_location.hunting_plot_id, user.id)
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

end
