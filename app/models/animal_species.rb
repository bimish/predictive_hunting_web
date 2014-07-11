class AnimalSpecies < ActiveRecord::Base

  validates :common_name, presence:true, length: { maximum: 100 }
  validates :species, presence:true, length: { maximum: 255 }

  def get_display_name
    self.common_name
  end

end
