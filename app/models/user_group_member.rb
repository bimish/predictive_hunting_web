class UserGroupMember < ActiveRecord::Base

  validates :user_group_id, presence:true
  validates :user_id, presence:true
  belongs_to :user_group
  belongs_to :user

  controller_assigned_attribute :user_group_id
  write_once_attribute :user_id

  def get_display_name
    "#{self.user_group.get_display_name} - #{self.user.get_display_name}"
  end

  def init_new(signed_in_user)
    super
  end

  def authorize_action?(user, action)
    case action
    when :read
      HuntingPlotUserAccess.can_access?(self.user_group.hunting_plot_id, user.id)
    when :create, :update, :delete
      HuntingPlotUserAccess.can_manage_members?(self.user_group.hunting_plot_id, user.id)
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

end
