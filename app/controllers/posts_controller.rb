class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    console
    @posts = Post.order(updated_at: :desc)
    @tags = sorted_tags.reverse
  end

  # GET /posts/filter/tag_name
  def filter
    @posts = Post.joins(:tags).where("tags.name" => params[:tag_name]).order(updated_at: :desc)
    @tags = sorted_tags.reverse
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    raise ActionController::RoutingError.new('Forbidden') if current_user.nil? || cannot?(:manage, @post)
  end

  # POST /posts
  # POST /posts.json
  def create
    raise ActionController::RoutingError.new('Forbidden') if current_user.nil? || cannot?(:write, :posts)
    @post = Post.new(post_params)
    @post.user = current_user if current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    raise ActionController::RoutingError.new('Forbidden') if current_user.nil? || cannot?(:manage, @post)
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    delete_unused_tags
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    raise ActionController::RoutingError.new('Forbidden') if current_user.nil? || cannot?(:manage, @post)
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
    delete_unused_tags
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:author, :title, :body, :tags_string)
  end

  # find unused tags and delete them
  def delete_unused_tags
    ActiveRecord::Base.connection.execute(
      "delete from tags where id in(
        select t.id from tags as t left join posts_tags as pt on pt.tag_id = t.id where pt.tag_id is null
      )"
    )
  end

  def sorted_tags
    Tag.all.map { |tag| { :name => tag.name, :count => tag.posts.count } }.sort! { |a, b| a[:count] <=> b[:count] }
  end
end
