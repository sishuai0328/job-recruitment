class ResumesController < ApplicationController

  before_action :authenticate_user!

  def new
    @job = Job.find_by_friendly_id!(params[:job_id])
    @resume = Resume.new
  end

  def create
    @job = Job.find_by_friendly_id!(params[:job_id])
    @resume = Resume.new(resume_params)
    @resume.job = @job
    @resume.user = current_user

    if @resume.save
      flash[:notice] = "成功提交履历"
      redirect_to job_path(@job)
    else
      render :new, notice: "成功提交履历"
    end
  end

  private

  def resume_params
    params.require(:resume).permit(:content, :attachment)
  end

end
