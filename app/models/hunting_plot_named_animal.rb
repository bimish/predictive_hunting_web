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

  def authorize_action?(user, crud_action)
    case crud_action
      when :create, :update, :delete
        # users can manage themselves or other users if they have the manage users permission
        HuntingPlotUserAccess.can_manage_named_animals?(self.hunting_plot_id, user.id)
      when :read
        # members of a hunting plot can see the named animals
        HuntingPlotUserAccess.exists?(hunting_plot_id: self.hunting_plot_id, user_id: user.id)
      else
        raise ArgumentError, "The specified action (#{crud_action}) is not supported"
    end
  end

  def self.search(params)
    search_results = HuntingPlotNamedAnimal.order(:name)
    search_results = search_results.where('hunting_plot_id = ?', params[:hunting_plot_id]) unless params[:hunting_plot_id].blank?
    #search_results = search_results.where('name ~* ?', "%#{params[:name]}%") unless params[:name].blank?
    search_results = search_results.where('name ~* ?', "#{params[:name]}") unless params[:name].blank?
    search_results
  end

end
