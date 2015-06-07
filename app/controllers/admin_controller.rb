class AdminController < ApplicationController

  before_action :authorize_action

  def authorize_action
    true
  end

end
