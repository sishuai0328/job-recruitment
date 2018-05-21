class Favorite::JobsController < ApplicationController

  before_action :authenticate_user!
  # def index
  #   @jobs = current_user.favorite_jobs #列出当前用户收藏的所有工作
  #
  # end

  def index
    @user = current_user
    @job_favorites = JobFavorite.where(:user => @user).order("created_at DESC").paginate(:page => params[:page], :per_page => 7)
  end

end
