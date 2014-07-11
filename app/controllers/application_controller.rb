class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  # custom helper modules
  helper :rgeo
  helper :item_commands
  helper :forms
  helper :bootstrap

#disable caching
def set_as_private
  expires_now
end

end
