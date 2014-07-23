class UserNetwork < ActiveRecord::Base

  validates :name, presence:true, length: { maximum: 100 }

  enum network_type:  { network_type_region: 1, network_type_composite: 2 }

  has_one :user_network_boundary
  has_many :member_networks, class:'CompositeNetworkMember', foreign_key:'composite_network_id'

  def get_display_name
    self.name
  end

end
