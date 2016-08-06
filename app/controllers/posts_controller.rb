class PostsController < ApplicationController

  before_action :require_log_in, except: :show
  before_action :current_post, only: [:show, :edit, :update]
  before_action :is_author, only: [:edit, :update]

  def new
    @post = Post.new
    @subs = Sub.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] ||= []
      flash.now[:errors] += @post.errors.full_messages
      render :new
    end
  end

  def show
    @comments = @post.comments.where(parent_comment_id: nil)
  end

  def edit
    @subs = Sub.all
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
    params.require(:post).permit(:title, :content, :url, :sub_ids => [])
  end

  def is_author
    if current_user.id != @post.user_id
      flash[:errors] ||= []
      flash[:errors] << "You are not the author"
      redirect_to subs_url
    end
  end

end
