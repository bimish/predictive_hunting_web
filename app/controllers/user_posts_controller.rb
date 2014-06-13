class UserPostsController < ApplicationController

  before_action :set_user_post, only: [:show, :edit, :update, :destroy, :delete]

  # GET /user_posts
  def index
    @user_posts = UserPost.all
  end

  # GET /user_posts/1
  def show
  end

  # GET /user_posts/new
  def new
    @user_post = UserPost.new
    @user_post.init_new current_user
  end

  # GET /user_posts/1/edit
  def edit
  end

  # POST /user_posts
  def create
    @user_post = UserPost.new(user_post_create_params)
    @user_post.init_new current_user

    respond_to do |format|
      if @user_post.save
        format.html { redirect_to @user_post, notice: 'User post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user_post }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @user_post.errors, status: :unprocessable_entity }
        format.js { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /user_posts/1
  def update
    respond_to do |format|
      if @user_post.update(user_post_update_params)
        format.html { redirect_to @user_post, notice: 'User post was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_post.errors, status: :unprocessable_entity }
        format.js { render action: 'edit' }
      end
    end
  end

  # DELETE /user_posts/1
  def destroy
    @user_post.destroy
    respond_to do |format|
      format.html { redirect_to user_posts_url, notice: 'User post was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  def status
    @user_post = UserPost.new
    @user_post.init_new current_user
    @user_post.post_content = params[:post_content]
    @user_post.visibility = params[:visibility]
    respond_to do |format|
      if @user_post.save
        format.js { render '/user_posts/status/create'}
      else
        format.js { render '/user_posts/status/new' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_post
      @user_post = UserPost.find(params[:id])
    end

    def user_post_update_params
      params.require(:user_post).permit(:post_content, :visibility)
    end

    def user_post_create_params
      params.require(:user_post).permit(:post_content, :visibility)
    end

end
