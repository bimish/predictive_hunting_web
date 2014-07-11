module UserPostsControllerExtensions

  class ViewData
    def visibilities
      @visibilities_map ||= UserPost.visibilities.collect { |item| [get_visibility_description(item[0]), item[0]] }
    end

    def get_visibility_description(visibility)
      visibility.sub("visibility_", "").humanize
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

