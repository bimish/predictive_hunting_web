class UserNetworkCategoriesController < ApplicationController

  before_action :set_user_network_category, only: [:show, :edit, :update, :destroy, :delete]

  include UserNetworkCategoriesControllerExtensions

  # GET /user_network_categories
  def index
    @user_network_categories = UserNetworkCategory.all
  end

  # GET /user_network_categories/1
  def show
  end

  # GET /user_network_categories/new
  def new
    @user_network_category = UserNetworkCategory.new
    @user_network_category.init_new current_user
  end

  # GET /user_network_categories/1/edit
  def edit
  end

  # POST /user_network_categories
  def create
    @user_network_category = UserNetworkCategory.new(user_network_category_create_params)
    @user_network_category.init_new current_user

    respond_to do |format|
      if @user_network_category.save
        format.html { redirect_to @user_network_category, notice: 'User network category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_network_category }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_network_category.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /user_network_categories/1
  def update
    respond_to do |format|
      if @user_network_category.update(user_network_category_update_params)
        format.html { redirect_to @user_network_category, notice: 'User network category was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_network_category.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /user_network_categories/1
  def destroy
    @user_network_category.destroy
    respond_to do |format|
      format.html { redirect_to user_network_categories_url, notice: 'User network category was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_network_category
      @user_network_category = UserNetworkCategory.find(params[:id])
    end

    def user_network_category_update_params
      params.require(:user_network_category).permit(:name, :is_composite, :parent_category_id)
    end

    def user_network_category_create_params
      params.require(:user_network_category).permit(:name, :is_composite, :parent_category_id)
    end

end
