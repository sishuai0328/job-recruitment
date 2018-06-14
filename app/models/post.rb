class Post < ApplicationRecord
  validates :content, presence: true
  # 统计访问量
  is_impressionable
  belongs_to :user
  belongs_to :group
  # has_many :votes
  has_many :votes, :dependent => :destroy
  has_many :voters, through: :votes, source: :user

  #是否已经点过赞
  def find_vote(user)
    self.votes.where( :user_id => user.id ).first
  end

  # 留言
  has_many :comments

  # 重构重复代码／最近排序
  scope :recent, -> { order('created_at DESC') }

end
