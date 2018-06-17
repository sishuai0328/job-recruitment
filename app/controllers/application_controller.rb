class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # 管理员权限
  def require_is_admin
    if !current_user.admin?
      flash[:alert] = '你不是企业用户，你没有权限进行此操作'
      redirect_to root_path
    end
  end

  def require_is_website_admin
    if !current_user.website_admin?
      redirect_to admin_jobs_path, alert: "你没有权限进行此操作。"
    end
  end

end
