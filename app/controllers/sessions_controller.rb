class SessionsController < ApplicationController

  #skip_before_filter :verify_authenticity_token, only => [:create]
  skip_before_action :verify_authenticity_token

  def new
  end
  def create
    email = params[:session][:email]
    user = User.find_by_email(email.downcase)
    respond_to do |format|
      if user && user.authenticate(params[:session][:password])
        sign_in user
        format.html { redirect_back_or root_path }
        format.json { head :no_content }
      else
        format.html {
          flash.now[:danger] = 'Invalid username/password combination'
          render 'new'
        }
        format.json { { :error => 'Invalid username/password combination' } }
      end
    end
  end
  def destroy
    sign_out
    redirect_back_or signin_path
  end
end
