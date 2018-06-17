class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy, :downvote, :upvote]
  before_action :find_post_and_check_permission , :only => [:edit, :update, :destroy]
  impressionist :actions=>[:show]

  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  # def new
  #   @group = Group.find(params[:group_id])
  #   if current_user.is_member_of?(@group)
  #     @post = Post.new
  #   else
  #     flash[:warning] = "你需要先加入群租"
  #   end
  #
  # end

  # 检索相关文章并显示，本质是posts和groups数据库映射
  def show
    @post = Post.find(params[:group_id])
    @group = @post.group
    impressionist(@post)
  end

  def edit
    @group = Group.find(params[:group_id])
    @post.group = @group
  end

  def update

    if @post.update(post_params)
      redirect_to account_posts_path, notice: "文章修改成功。"
    else
      render :edit
    end
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.group = @group
    @post.destroy
    redirect_to account_posts_path, alert: "文章已删除，且不可恢复！"
  end

  # def upvote
  #   @post = Post.find(params[:id])
  #
  #    if !current_user.is_voter_of?(@post)
  #      current_user.upvote!(@post)
  #    end
  #
  #    redirect_to :back
  #  end
  #
  #  def downvote
  #    @post = Post.find(params[:id])
  #
  #    if current_user.is_voter_of?(@post)
  #      current_user.downvote!(@post)
  #    end
  #    redirect_to :back
  #  end

   def upvote
     @post = Post.find(params[:id])
     unless @post.find_vote(current_user)  # 如果已经按讚过了，就略过不再新增
       Vote.create( :user => current_user, :post => @post)
     end

     redirect_to :back
   end

   def downvote
     @post = Post.find(params[:id])
     vote = @post.find_vote(current_user)
     vote.destroy

     redirect_to :back
   end



  private

  def post_params
    params.require(:post).permit(:title, :content )
  end

  def find_post_and_check_permission
    @post = Post.find(params[:id])
    if current_user != @post.user
      redirect_to root_path, alert: "You have no permission"
    end
  end

end
