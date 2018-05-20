class JobsController < ApplicationController
  # 需要登录的操作
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :validate_search_key, only: [:search]

  # def index
  #
  #   @jobs = case params[:order]
  #     when 'by_lower_bound'
  #       Job.published.order('wage_lower_bound DESC')
  #     when 'by_upper_bound'
  #       Job.published.order('wage_upper_bound DESC')
  #     else
  #       Job.published.recent
  #   end
  #
  # end

  def index
    @locations = Location.all
    @categorys = Category.all

    # 判断是否筛选城市 #
    if params[:location].present?
      @location = params[:location]
      @location_id = Location.find_by(name: @location)

      if @location == '所有城市'
        @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.where(:location => @location_id).published.recent.paginate(:page => params[:page], :per_page => 10)
      end

    # 判断是否筛选职位类型 #
    elsif params[:category].present?
      @category = params[:category]
      @category_id = Category.find_by(name: @category)

      if @category == '所有类型'
        @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.where(:category => @category_id).published.recent.paginate(:page => params[:page], :per_page => 10)
      end

    # 判断是否筛选薪水 #
    elsif params[:wage].present?
      @wage = params[:wage]
      if @wage == '5k以下'
        @jobs = Job.wage1.published.recent.paginate(:page => params[:page], :per_page => 10)
      elsif @wage == '5~10k'
        @jobs = Job.wage2.published.recent.paginate(:page => params[:page], :per_page => 10)
      elsif @wage == '10~15k'
        @jobs = Job.wage3.published.recent.paginate(:page => params[:page], :per_page => 10)
      elsif @wage == '15~25k'
        @jobs = Job.wage4.published.recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.wage5.published.recent.paginate(:page => params[:page], :per_page => 10)
      end

    # elsif @jobs = case params[:order]
    #     when 'by_lower_bound'
    #       Job.published.order('wage_lower_bound DESC')
    #     when 'by_upper_bound'
    #       Job.published.order('wage_upper_bound DESC')
    #     else
    #       Job.published.recent
    # end

    # 预设显示所有公开职位 #
    else
      @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    @job = Job.find(params[:id])
    @category = @job.category
    # 搜索该用户投递此职位的简历数量 #
    @resumes = Resume.where(:job => @job, :user => current_user)
    if @job.is_hidden
      redirect_to root_path, alert: "此职缺暂未开放。"
    end
  end


  def search
      if @query_string.present?
        search_result = Job.joins(:location).ransack(@search_criteria).result(:distinct => true)
        @jobs = search_result.published.paginate(:page => params[:page], :per_page => 5 )
      end
    end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])

    @job.destroy

    redirect_to jobs_path
  end

  # 隐藏／显示职位提示
  # def show
  #   @job = Job.find(params[:id])
  #
  #   if @job.is_hidden
  #     flash[:warning] = "This Job already archieved"
  #     redirect_to root_path
  #   end
  # end

  def favorites
    @job = Job.find(params[:id])
    if !current_user.is_favorite_of?(@job)
      current_user.favorite!(@job)
      flash[:notice] = "收藏成功，可以到我收藏的工作中查看。"
    else
      flash[:warning] = "此工作已收藏！"
    end
      redirect_to :back
  end

  def unfavorite
   @job = Job.find(params[:id])
   if current_user.is_favorite_of?(@job)
     current_user.unfavorite!(@job)
     flash[:notice] = "已取消收藏"
   else
     flash[:warning] = "此工作未被收藏！"
   end
     redirect_to :back
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :company, :category_id, :location_id, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden)
  end

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
    if params[:q].present?
      @search_criteria =  {
        title_or_company_or_location_name_cont: @query_string
      }
    end
  end

  def search_criteria(query_string)
    { :title_or_company_or_location_name_cont => query_string }
  end

end
