class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :resumes
  has_many :groups
  has_many :posts

  # 参与讨论组
  has_many :group_relationships
  has_many :participated_groups, :through => :group_relationships, :source => :group

  # 收藏职位
  has_many :job_favorites
  has_many :favorite_jobs, through: :job_favorites, source: :job

  # 是否为管理员
  # 判断数据库中的管理员栏位的布尔值
  def admin?
    is_admin
  end

  # 是否已收藏职位
  def is_favorite_of?(job)
    favorite_jobs.include?(job)
  end

  # 收藏职位
  def favorite!(job)
    favorite_jobs << job
  end

  # 取消收藏职位
  def unfavorite!(job)
    favorite_jobs.delete(job)
  end

  # 是否为群组里的一员？
  def is_member_of?(group)
    participated_groups.include?(group)
  end

  # 加入群组
  def join!(group)
    participated_groups << group
  end

  # 退出群组
  def quit!(group)
    participated_groups.delete(group)
  end

  #  是否投递过
  def is_upload_of?(job)
    resumes.include?(job)
  end

end
