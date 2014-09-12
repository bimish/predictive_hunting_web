module UsersControllerExtensions

  class ViewData
    def authentication_methods
      @authentication_methods_map ||= User.authentication_methods.collect { |item| [get_authentication_method_description(item[0]), item[0]] }
    end

    def get_authentication_method_description(authentication_method)
      authentication_method.sub("authentication_method_", "").humanize
    end

    def get_admin_description(admin_value)
      admin_value.to_s
    end
  end

  extend ActiveSupport::Concern

  def set_users
    if (!current_user.admin?)
      @users = User.where(id: current_user.id)
    end
  end

  def sign_in_user
    sign_in(@user)
  end

  included do
    before_action :set_view_data
    before_action :set_users, only: [:index]
    after_action :sign_in_user, only: [:create]
  end

private

  def set_view_data
    @view_data = ViewData.new()
  end

end

