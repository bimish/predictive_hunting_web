class UserNetworkCategory < ActiveRecord::Base

  validates :name, presence:true, length: { maximum: 100 }
  validates :is_composite, inclusion: [true,false]

  belongs_to :parent_category, class_name:'UserNetworkCategory'

  def get_display_name
    self.name
  end

end
