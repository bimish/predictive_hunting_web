class UserNetwork < ActiveRecord::Base

  validates :name, presence:true, length: { maximum: 100 }

  belongs_to :parent_network, class_name:'UserNetwork', foreign_key:'parent_network_id'
  has_many :child_networks, class_name:'UserNetwork', foreign_key:'parent_network_id'

  belongs_to :category, class_name:'UserNetworkCategory', foreign_key:'category_id'

  has_many :boundaries, class_name:'UserNetworkBoundary'
  has_many :member_networks, class_name:'CompositeNetworkMember', foreign_key:'composite_network_id'

  def get_display_name
    self.name
  end

  def self.root_level_networks
    self.where(parent_network_id: nil)
  end

end
