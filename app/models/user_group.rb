class UserGroup < ActiveRecord::Base

  validates :name, presence:true, length: { maximum: 100 }
  belongs_to :hunting_plot
  has_many :members, class_name:'UserGroupMember'
  enum group_type: { location_access: 1 }

  controller_assigned_attribute :hunting_plot_id
  component_assigned_attribute :group_type  # type is a placeholder for now. until we have more than one type, we can always assign a value of 1 and ignore

  def get_display_name
    self.name
  end

  def init_new(signed_in_user)
    super
    self.group_type = UserGroup.group_types[:location_access] # type is a placeholder for now. until we have more than one type, we can always assign a value of 1 and ignore
  end

  def authorize_action?(user, action)
    case action
    when :read
      HuntingPlotUserAccess.can_access?(self.hunting_plot_id, user.id)
    when :create, :update, :delete
      HuntingPlotUserAccess.can_manage_members?(self.hunting_plot_id, user.id)
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

  def set_members(user_ids)
    existing_user_ids = self.members.pluck(:user_id)
    ActiveRecord::Base.transaction do
      user_ids.each do |user_id|
        unless existing_user_ids.include?(user_id)
          UserGroupMember.create!(user_group_id: self.id, user_id: user_id)
        end
      end
      existing_user_ids.each do |user_id|
        unless user_ids.include?(user_id)
          UserGroupMember.find_by(user_group_id: self.id, user_id: user_id).destroy
        end
      end
    end
  end

end
