class FriendsController < ApplicationController

  before_filter :ensure_signed_in, only: [:index, :edit, :update, :destroy]

  before_action :set_user_relationship, only: [:show, :edit, :update, :destroy, :delete]
  before_action :authorize_action, only: [:show, :edit, :update, :destroy, :delete]

  # GET /friends
  def index
    @user_relationships = current_user.relationships.preload(:related_user)
  end

  # GET /friends/1
  def show
  end

  # GET /friends/new
  def new
    @user_relationship = UserRelationship.new
    @user_relationship.init_new current_user
    @existing_requests = RelationshipRequest.where(created_by_id: current_user.id)
  end

  def new_friend_search
    #@users = User.joins('LEFT OUTER JOIN user_relationship ON ("user".id = user_relationship.related_user_id AND user_relationship.owning_user_id = 2)').where(admin: false).where('user_relationship.related_user_id IS NULL').where.not(id: current_user.id)
    @users = User.search_new_friends(current_user, params[:name])
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends
  # def create
  #   @user_relationship = UserRelationship.new(user_relationship_create_params)
  #   @user_relationship.init_new current_user
  #   respond_to do |format|
  #     if @user_relationship.save
  #       format.html { redirect_to @user_relationship, notice: 'User relationship was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @user_relationship }
  #       format.js
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @user_relationship.errors, status: :unprocessable_entity }
  #       format.js { render action: 'new' }
  #     end
  #   end
  # end

  # PATCH/PUT /friends/1
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

  # DELETE /friends/1
  def destroy
    UserRelationship.remove_relationship @user_relationship
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

    def authorize_action
      raise Exceptions::NotAuthorized unless @user_relationship.authorize_action?(current_user, params[:action].to_sym)
    end

end
