class AnimalActivityType < ActiveRecord::Base

  validates :name, presence:true, length: { maximum: 100 }
  validates :gender, presence:true, length: { maximum: 100 }
  validates :maturity, presence:true
  validates :trophy_rating, presence:true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  def get_display_name
    self.name
  end

end
