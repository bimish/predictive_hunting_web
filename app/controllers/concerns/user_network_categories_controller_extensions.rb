module UserNetworkCategoriesControllerExtensions

  class ViewData
    def parent_categories
      @parent_categories_map ||= UserNetworkCategory.where(is_composite: true).map { |m| [m.name, m.id] }
    end
  end

  extend ActiveSupport::Concern

  included do
    before_action :set_view_data
  end

private

  def set_view_data
    @view_data = ViewData.new()
  end

end

