class UserNetworkSubscription < ActiveRecord::Base

  validates :user_id, presence: true
  validates :user_network_id, presence: true, :uniqueness => { :scope => :user_id }

  belongs_to :user
  belongs_to :network, class_name:'UserNetwork', foreign_key:'user_network_id'

  component_assigned_attribute :user_id

  def get_display_name
    self.network.name
  end

  def authorize_action?(user, action)
    case action
    when :show, :create, :update, :destroy
      self.user_id == user.id
    else
      raise ArgumentError, 'The specified action (' + action.to_s + ') is not supported'
    end
  end

  def init_new(signed_in_user)
    super
    self.user_id = signed_in_user.id unless signed_in_user.nil?
  end

private

end
