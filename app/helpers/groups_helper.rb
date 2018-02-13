module GroupsHelper
  # 自定义方法
  def render_group_description(group)
    simple_format(group.description)
  end

end
