class AnimalCategory < ActiveRecord::Base

  validates :name, presence:true, length: { maximum: 100 }

  belongs_to :animal_species

  def get_display_name
    self.name
  end

end
