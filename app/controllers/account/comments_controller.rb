class Account::CommentsController < ApplicationController
  def index
    @user = current_user
    @comments = Comment.where(:user_id => @user).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
  end
end
