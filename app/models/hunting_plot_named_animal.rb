class HuntingPlotNamedAnimal < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 100 }
  validates :animal_category_id, presence: true

  belongs_to :hunting_plot
  belongs_to :animal_species
  belongs_to :animal_category

  controller_assigned_attribute :hunting_plot_id

  def get_display_name
    self.name
  end

  def self.search(params)
    search_results = HuntingPlotNamedAnimal.order(:name)
    search_results = search_results.where('hunting_plot_id = ?', params[:hunting_plot_id]) unless params[:hunting_plot_id].blank?
    #search_results = search_results.where('name ~* ?', "%#{params[:name]}%") unless params[:name].blank?
    search_results = search_results.where('name ~* ?', "#{params[:name]}") unless params[:name].blank?
    search_results
  end

end
