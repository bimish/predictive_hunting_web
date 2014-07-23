class UserNetworkSubscription < ActiveRecord::Base

  validates :user_id, presence: true
  validates :network_id, presence: true, :uniqueness => { :scope => :user_id }

  belongs_to :user
  belongs_to :network, class:'UserNetwork'

  component_assigned_attribute :user_id

  set_new_record_initializer :new_record_init

private
  def new_record_init(signed_in_user)
    self.user_id = signed_in_user.id unless signed_in_user.nil?
  end

end
