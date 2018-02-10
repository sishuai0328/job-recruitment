class Job < ApplicationRecord
  # 标题不能为空
  validates :title, presence: true
  #薪资不能为空，最低底薪大于0
  validates :wage_upper_bound, presence: true
  validates :wage_lower_bound, presence: true
  validates :wage_lower_bound, numericality: { greater_than: 0}
  # 重构重复代码／公开
  scope :published, -> { where(is_hidden: false) }
  # 重构重复代码／最近排序
  scope :recent, -> { order('created_at DESC') }

  has_many :resumes


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
