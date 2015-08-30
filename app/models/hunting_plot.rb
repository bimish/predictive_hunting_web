class HuntingPlot < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 100 }

  has_many :locations, :class_name => 'HuntingLocation'
  has_many :named_animals, :class_name => 'HuntingPlotNamedAnimal'
  has_many :user_accesses, :class_name => 'HuntingPlotUserAccess'
  has_many :user_access_requests, :class_name => 'HuntingPlotUserAccessRequest'
  has_many :users, through: :user_accesses, :class_name => 'User'
  has_many :user_groups, :class_name => 'UserGroup'

  def get_display_name
    self.name
  end

  def authorize_action?(user, action)
    case action
    when :read
      HuntingPlotUserAccess.can_access? self.id, user.id
    when :create, :destroy
      user.admin?
    when :update
      HuntingPlotUserAccess.can_administrate? self.id, user.id
    else
      raise ArgumentError, 'The specified action is not supported'
    end
  end

end
