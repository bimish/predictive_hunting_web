class UserGroupsController < ComponentController

  include UserGroupsControllerExtensions

  # GET /user_groups
  def index
    @user_groups ||= UserGroup.all
  end

  # GET /user_groups/1
  def show
  end

  # GET /user_groups/new
  def new
  end

  # GET /user_groups/1/edit
  def edit
  end

  # POST /user_groups
  def create
    respond_to do |format|
      if @user_group.save
        format.html { redirect_to @user_group, notice: 'User group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_group }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /user_groups/1
  def update
    respond_to do |format|
      if @user_group.update(update_params)
        format.html { redirect_to @user_group, notice: 'User group was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_group.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /user_groups/1
  def destroy
    @user_group.destroy
    respond_to do |format|
      format.html { redirect_to user_groups_url, notice: 'User group was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    def get_component
      @user_group = UserGroup.find(params[:id])
    end

    def new_component(params = nil)
      @user_group = UserGroup.new(params)
    end

    def update_params
      params.require(:user_group).permit(:name)
    end

    def create_params
      params.require(:user_group).permit(:name)
    end

end
