class UserInvitationsController < ComponentController

  include UserInvitationsControllerExtensions

  # GET /user_invitations
  def index
    @user_invitations ||= UserInvitation.all
  end

  # GET /user_invitations/1
  def show
  end

  # GET /user_invitations/new
  def new
  end

  # GET /user_invitations/1/edit
  def edit
  end

  # POST /user_invitations
  def create
    respond_to do |format|
      if @user_invitation.save
        format.html { redirect_to @user_invitation, notice: 'User invitation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_invitation }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_invitation.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /user_invitations/1
  def update
    respond_to do |format|
      if @user_invitation.update(update_params)
        format.html { redirect_to @user_invitation, notice: 'User invitation was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_invitation.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /user_invitations/1
  def destroy
    @user_invitation.destroy
    respond_to do |format|
      format.html { redirect_to user_invitations_url, notice: 'User invitation was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def get_component
      @user_invitation = UserInvitation.find(params[:id])
    end

    def new_component(params = nil)
      @user_invitation = UserInvitation.new(params)
    end

    def update_params
      params.require(:user_invitation).permit(:message, :status)
    end

    def create_params
      params.require(:user_invitation).permit(:email, :message, :status)
    end

end
