class CompositeNetworkMember < ActiveRecord::Base

  validates :composite_network_id, presence: true
  validates :member_network_id, presence: true, :uniqueness => { :scope => :composite_network_id }

  belongs_to :composite_network, class_name:'UserNetwork', foreign_key:'composite_network_id'
  belongs_to :member_network, class_name:'UserNetwork', foreign_key:'member_network_id'

  component_assigned_attribute :composite_network_id

end
