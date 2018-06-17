class Account::GroupsController < ApplicationController
  before_action :authenticate_user!

  # 参与过的群组
  def index
    @groups = current_user.participated_groups.paginate(:page => params[:page], :per_page => 5)
  end
end
