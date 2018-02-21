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

  def index
    @jobs = Job.all
    @categorys = Category.all
  end

  def new
    @job = Job.new
    @categorys = Category.all
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
    params.require(:job).permit(:title, :description, :category_id, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden)
  end
end
