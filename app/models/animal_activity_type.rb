class AnimalActivityType < ActiveRecord::Base

  validates :name, presence:true, length: { maximum: 100 }

  def get_display_name
    self.name
  end

end
