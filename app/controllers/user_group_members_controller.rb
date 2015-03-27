class UserGroupMembersController < ComponentController

  include UserGroupMembersControllerExtensions

  # GET /user_group_members
  def index
    @user_group_members ||= UserGroupMember.all
  end

  # GET /user_group_members/1
  def show
  end

  # GET /user_group_members/new
  def new
  end

  # GET /user_group_members/1/edit
  def edit
  end

  # POST /user_group_members
  def create
    respond_to do |format|
      if @user_group_member.save
        format.html { redirect_to @user_group_member, notice: 'User group member was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_group_member }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_group_member.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /user_group_members/1
  def update
    respond_to do |format|
      if @user_group_member.update(update_params)
        format.html { redirect_to @user_group_member, notice: 'User group member was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_group_member.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /user_group_members/1
  def destroy
    @user_group_member.destroy
    respond_to do |format|
      format.html { redirect_to user_group_members_url, notice: 'User group member was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def get_component
      @user_group_member = UserGroupMember.find(params[:id])
    end

    def new_component(params = nil)
      @user_group_member = UserGroupMember.new(params)
    end

    def update_params
      params.require(:user_group_member).permit()
    end

    def create_params
      params.require(:user_group_member).permit(:user_id)
    end

end
