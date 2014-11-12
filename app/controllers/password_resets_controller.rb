class PasswordResetsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:email])
    user.reset_password if user
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired"
    else
      @user.update(params.require(:user).permit(:password, :password_confirmation))
      if @user.save
        redirect_to signin_url, :notice => "Password has been reset"
      else
        render :edit
      end
    end
  end

end
