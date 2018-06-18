class Account::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @post = Post.find_by_friendly_id!(params[:group_id])
    @group = @post.group
  end


end
