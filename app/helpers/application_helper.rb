module ApplicationHelper

  # 登录弹窗开始
  def resource_name
    :user
  end

  def resource
      @resource ||= User.new
  end

  def resource_class
      User
  end

  def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
  end
  # 登录弹窗结束

end
