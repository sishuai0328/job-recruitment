class Post < ApplicationRecord
  validates :content, presence: true
  # 统计访问量
  is_impressionable
  belongs_to :user
  belongs_to :group

  # 重构重复代码／最近排序
  scope :recent, -> { order('created_at DESC') }

end
