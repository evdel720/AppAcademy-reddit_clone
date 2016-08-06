class CommentsController < ApplicationController

  before_action :require_log_in

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = params[:post_id]
    @comment.parent_comment_id = params[:comment_id] unless params[:comment_id] == ""
    if @comment.save
      redirect_to post_url(params[:post_id])
    else
      flash[:errors] ||= []
      flash[:errors] += @comment.errors.full_messages
      redirect_to post_url(params[:post_id])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
