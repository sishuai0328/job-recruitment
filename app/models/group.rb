class Group < ApplicationRecord
 mount_uploader :avatar, AvatarUploader
 validates :title, presence: true

 belongs_to :user
 has_many :posts

 # rails g model group_relationship group_id:integer user_id:integer
 # 参与的讨论群
 has_many :group_relationships
 # 一个讨论组包括成员
 has_many :members, through: :group_relationships, source: :user

end
