class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all.paginate(:page => params[:page], :per_page => 5)
    # @user = current_user
    # @groups = Group.where(:user_id => @user).order("created_at DESC").paginate(:page => params[:page], :per_page => 7)
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end


  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      # 创建之后自动加入
      current_user.join!(@group)
      redirect_to groups_path, notice: "讨论版块创建成功。"
    else
      render :new
    end
  end

  def edit
  end

  def update

    if @group.update(group_params)
      redirect_to groups_path, notice: "讨论版块修改成功。"
    else
      render :edit
    end
  end

  def destroy

    @group.destroy
    redirect_to groups_path, alert: "讨论版块已删除，且不可恢复！"
  end

  def join
   @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      # 创建之后自动加入
      current_user.join!(@group)
      flash[:notice] = "加入本讨论版成功！"
    else
      flash[:warning] = "你已经是本讨论版成员了！"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本讨论版！"
    else
      flash[:warning] = "你不是本讨论版成员，怎么退出"
    end

    redirect_to group_path(@group)
  end

  private

  def find_group_and_check_permission
    @group = Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def group_params
    params.require(:group).permit(:title, :description, :avatar)
  end
end
