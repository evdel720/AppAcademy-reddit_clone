class PostsController < ApplicationController

  before_action :require_log_in, except: :show
  before_action :current_post, only: [:show, :edit, :update]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.sub_id = params[:sub_id]
    @post.user_id = current_user.id
    if @post.save
      redirect_to sub_url(params[:sub_id])
    else
      flash.now[:errors] ||= []
      flash.now[:errors] += @post.errors.full_messages
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] ||= []
      flash.now[:errors] += @post.errors.full_messages
      render :edit
    end
  end

  private

  def current_post
    @post = Post.find_by(id: params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :url)
  end

end
