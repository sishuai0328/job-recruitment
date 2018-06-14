class Admin::ResumesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin

  layout 'admin'

  def index
    @job = Job.find_by_friendly_id!(params[:job_id])
    @resumes = @job.resumes.order('created_at DESC')
  end

end
