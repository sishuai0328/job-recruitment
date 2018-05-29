class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_website_admin

  layout "admin"

    def index
      @categorys = Category.all
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)

      if @category.save!
        redirect_to admin_categories_path, notice: "职位类型新增成功。"
      else
        render :new
      end
    end

    def edit
      @category = Category.find(params[:id])
    end

    def update
      @category = Category.find(params[:id])
      @category.update(category_params)

      if @category.save
        redirect_to admin_categories_path, notice: "职位类型修改成功。"
      else
        render :edit
      end
    end

    def destroy
      @category = Category.find(params[:id])

      @category.destroy

      redirect_to admin_categories_path, notice: "职位类型删除成功。"
    end


  private

    def category_params
      params.require(:category).permit(:name,:icon)
    end

end
