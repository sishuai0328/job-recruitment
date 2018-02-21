class Admin::LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin

  layout "admin"

    def index
      @locations = Location.all
    end

    def new
      @location = Location.new
    end

    def create
      @location = Location.new(location_params)

      if @location.save!
        redirect_to admin_locations_path, notice: "工作地点新增成功。"
      else
        render :new
      end
    end

    def edit
      @location = Location.find(params[:id])
    end

    def update
      @location = Location.find(params[:id])
      @location.update(location_params)

      if @location.save
        redirect_to admin_locations_path, notice: "工作地点修改成功。"
      else
        render :edit
      end
    end

    def destroy
      @location = Location.find(params[:id])

      @location.destroy

      redirect_to admin_locations_path, notice: "工作地点删除成功。"
    end


  private

    def location_params
      params.require(:location).permit(:name)
    end
end
