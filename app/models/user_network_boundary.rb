class UserNetworkBoundary < ActiveRecord::Base

  validates :user_network_id, presence: true
  #validates :boundary, presence: true
  belongs_to :user_network

end
