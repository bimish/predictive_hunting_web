require "app/exceptions"

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
  helper :enums
  helper :nested_urls
  helper :map
  helper :mail
  helper :client_json
  helper ConfigData

#disable caching
def set_as_private
  expires_now
end

end
