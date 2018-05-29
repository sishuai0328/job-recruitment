class Job < ApplicationRecord
  # 标题不能为空
  validates :title, presence: true
  #薪资不能为空，最低底薪大于0
  validates :wage_upper_bound, presence: true
  validates :wage_lower_bound, presence: true
  validates :wage_lower_bound, numericality: { greater_than: 0}
  # 重构重复代码／公开
  scope :published, -> { where(is_hidden: false) }
  scope :random5, -> { limit(5).order("RANDOM()") }
  # 重构重复代码／最近排序
  scope :recent, -> { order('created_at DESC') }
  scope :wage1, -> { where('wage_lower_bound <= 5 or wage_upper_bound <= 5') }
  scope :wage2, -> { where('wage_lower_bound between 5 and 10 or wage_upper_bound between 5 and 10') }
  scope :wage3, -> { where('wage_lower_bound between 10 and 15 or wage_upper_bound between 10 and 15') }
  scope :wage4, -> { where('wage_lower_bound between 15 and 25 or wage_upper_bound between 15 and 25') }
  scope :wage5, -> { where('wage_lower_bound >= 25 or wage_upper_bound >= 25') }

  # has_many :resumes
  has_many :resumes, dependent: :destroy

  # 收藏职位
  has_many :job_favorites
  has_many :collectors, through: :job_favorites, source: :user

  # 职位类别
  belongs_to :category

  # 工作地点
  belongs_to :location

  # 公开职位
  def publish!
    self.is_hidden = false
    self.save
  end

  # 隐匿职位
  def hide!
    self.is_hidden = true
    self.save
  end

end
