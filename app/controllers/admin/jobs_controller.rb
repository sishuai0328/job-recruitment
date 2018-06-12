class Admin::JobsController < ApplicationController
  # 需要登录的操作
  before_action :authenticate_user!
  # 需要admin权限
  before_action :require_is_admin
  before_action :find_job_and_check_permission , only: [:edit, :update]
  # 套用管理界面样式
  layout "admin"

  def show
    @job = Job.find_by_friendly_id!(params[:id])
  end

  # def index
  #   @jobs = Job.all
  #   @categorys = Category.all
  #   @locations = Location.all
  # end

  def index
    @locations = Location.all
    @categorys = Category.all

    # 判断是否筛选城市 #
    if params[:location].present?
      @location = params[:location]
      @location_id = Location.find_by(name: @location)

      if @location == '所有城市'
        @jobs = Job.where(:user => current_user).recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.where(:user => current_user, :location_id => @location_id).recent.paginate(:page => params[:page], :per_page => 10)
      end

    # 判断是否筛选职位类型 #
    elsif params[:category].present?
      @category = params[:category]
      @category_id = Category.find_by(name: @category)

      if @category == '所有类型'
        @jobs = Job.where(:user => current_user).recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.where(:user => current_user, :category => @category_id).recent.paginate(:page => params[:page], :per_page => 10)
      end

    # 判断是否筛选薪水 #
    elsif @jobs = case params[:order]
        when 'by_lower_bound'
          Job.where(:user => current_user).order('wage_lower_bound DESC')
        when 'by_upper_bound'
          Job.where(:user => current_user).order('wage_upper_bound DESC')
        else
          Job.where(:user => current_user).recent
    end

    # 预设显示所有公开职位 #
    else
      @jobs = Job.where(:user => current_user).published.recent.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def new
    @job = Job.new
    @categorys = Category.all
    @locations = Location.all
  end

  def create
    @job = Job.new(job_params)
    @job.user = current_user

    if @job.save
      redirect_to admin_jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find_by_friendly_id!(params[:id])
    @categorys = Category.all
    @locations = Location.all
  end

  def update
    @job = Job.find_by_friendly_id!(params[:id])
    if @job.update(job_params)
      redirect_to admin_jobs_path, notice: '职位修改成功。'
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find_by_friendly_id!(params[:id])

    @job.destroy

    redirect_to admin_jobs_path
  end

 def publish
    @job = Job.find_by_friendly_id!(params[:id])
    @job.publish!

    redirect_to :back
  end

  def hide
    @job = Job.find_by_friendly_id!(params[:id])

    @job.hide!

    redirect_to :back
  end


  private

  def find_job_and_check_permission
    @job = Job.find(params[:id])

    if @job.user != current_user
      redirect_to root_path, alert: "你没有权限进行此操作。"
    end
  end

  def job_params
    params.require(:job).permit(:title, :description, :company, :category_id, :location_id, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden)
  end
end
