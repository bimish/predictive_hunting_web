class SessionsController < ApplicationController
  def new
  end
  def create
    email = params[:session][:email].downcase!
    user = User.find_by_email(email)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or root_path
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end
  def destroy
    sign_out
    redirect_to root_path
  end
end
