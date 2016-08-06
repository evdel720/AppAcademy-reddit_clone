class SubsController < ApplicationController
  before_action :require_log_in, except: [:show, :index]
  before_action :current_sub, only: [:show, :edit, :update]
  before_action :is_author, only: [:edit, :update]

  def index
    @subs = Sub.all
  end

  def new
    @sub = Sub.new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.user_id = current_user.id
    if @sub.save
      redirect_to subs_url
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @sub.update(sub_params)
      redirect_to sub_url(@sub.id)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end


  private

  def is_author
    if current_user.id != @sub.moderator.id
      flash[:errors] = ["You are not the author of this sub."]
      redirect_to subs_url
    end
  end

  def current_sub
    @sub = Sub.find_by(id: params[:id])
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

end
