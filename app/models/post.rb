class Post < ApplicationRecord
  validates :content, presence: true
  # 统计访问量
  is_impressionable
  belongs_to :user
  belongs_to :group
  has_many :votes
  has_many :voters, through: :votes, source: :user
  # 留言
  has_many :comments

  # 重构重复代码／最近排序
  scope :recent, -> { order('created_at DESC') }

end
