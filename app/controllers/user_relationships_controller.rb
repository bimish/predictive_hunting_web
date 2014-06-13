class UserRelationshipsController < ApplicationController
  before_action :set_user_relationship, only: [:show, :edit, :update, :destroy, :delete]

  # GET /user_relationships
  def index
    @user_relationships = UserRelationship.all
  end

  # GET /user_relationships/1
  def show
  end

  # GET /user_relationships/new
  def new
    @user_relationship = UserRelationship.new(:signed_in_user => current_user)
  end

  # GET /user_relationships/1/edit
  def edit
  end

  # POST /user_relationships
  def create
    @user_relationship = UserRelationship.new(:signed_in_user => current_user, :params => user_relationship_create_params)

    respond_to do |format|
      if @user_relationship.save
        format.html { redirect_to @user_relationship, notice: 'User relationship was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_relationship }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_relationship.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /user_relationships/1
  def update
    respond_to do |format|
      if @user_relationship.update(user_relationship_update_params)
        format.html { redirect_to @user_relationship, notice: 'User relationship was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_relationship.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /user_relationships/1
  def destroy
    @user_relationship.destroy
    respond_to do |format|
      format.html { redirect_to user_relationships_url, notice: 'User relationship was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_relationship
      @user_relationship = UserRelationship.find(params[:id])
    end

    def user_relationship_update_params
      params.require(:user_relationship).permit(:relationship_type)
    end

    def user_relationship_create_params
      params.require(:user_relationship).permit(:related_user_id, :relationship_type)
    end

end
