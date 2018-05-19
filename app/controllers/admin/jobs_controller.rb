class Admin::JobsController < ApplicationController
  # 需要登录的操作
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  # 需要admin权限
  before_action :require_is_admin
  # 套用管理界面样式
  layout "admin"

  def show
    @job = Job.find(params[:id])
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
        @jobs = Job.recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.where(:location => @location_id).recent.paginate(:page => params[:page], :per_page => 10)
      end

    # 判断是否筛选职位类型 #
    elsif params[:category].present?
      @category = params[:category]
      @category_id = Category.find_by(name: @category)

      if @category == '所有类型'
        @jobs = Job.recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.where(:category => @category_id).recent.paginate(:page => params[:page], :per_page => 10)
      end

    # 判断是否筛选薪水 #
    elsif @jobs = case params[:order]
        when 'by_lower_bound'
          Job.order('wage_lower_bound DESC')
        when 'by_upper_bound'
          Job.order('wage_upper_bound DESC')
        else
          Job.recent
    end

    # 预设显示所有公开职位 #
    else
      @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def new
    @job = Job.new
    @categorys = Category.all
    @locations = Location.all
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      redirect_to admin_jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
    @categorys = Category.all
    @locations = Location.all
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to admin_jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])

    @job.destroy

    redirect_to admin_jobs_path
  end

 def publish
    @job = Job.find(params[:id])
    @job.publish!

    redirect_to :back
  end

  def hide
    @job = Job.find(params[:id])

    @job.hide!

    redirect_to :back
  end


  private

  def job_params
    params.require(:job).permit(:title, :description, :company, :category_id, :location_id, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden)
  end
end
