module UsersControllerExtensions

  class ViewData
    def authentication_methods
      @authentication_methods_map ||= User.authentication_methods.collect { |item| [get_authentication_method_description(item[0]), item[0]] }
    end

    def get_authentication_method_description(authentication_method)
      authentication_method.sub("authentication_method_", "").humanize
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

