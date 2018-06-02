class CommentsController < ApplicationController
before_action :authenticate_user!, :only => [:new, :create, :destroy, :like, :unlike]

  # def create
  #   @post = Post.find(params[:post_id])
  #   @comment = @post.comments.create(params[:comment].permit(:name, :comment))
  #   @user = User.find(params[:user_id])
  #   redirect_to :back
  # end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(params[:comment].permit(:name, :comment))
    @comment.user = current_user
    @comment.save
    redirect_to :back
  end

  def destroy
    @comment = Comment.find(params[:post_id])
    @comment.post = @post
    @comment.destroy
    redirect_to :back
  end

  def like
   @comment = Comment.find(params[:post_id])
   @comment.post = @post
    if !current_user.is_liker_of?(@comment)
      current_user.like!(@comment)
    end
    @comment.save
    redirect_to :back
  end

  def unlike
    @comment = Comment.find(params[:post_id])
    @comment.post = @post
    if current_user.is_liker_of?(@comment)
      current_user.unlike!(@comment)
    end
    @comment.save
    redirect_to :back
  end

end
