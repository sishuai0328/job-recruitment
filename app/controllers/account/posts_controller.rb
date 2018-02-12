class Account::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts
  end

  def show
    @post = Post.find(params[:group_id])
    @group = @post.group
  end


end
