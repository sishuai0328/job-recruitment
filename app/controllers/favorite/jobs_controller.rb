class Favorite::JobsController < ApplicationController
  
  before_action :authenticate_user!
  def index
    @jobs = current_user.favorite_jobs #列出当前用户收藏的所有工作

  end

end
