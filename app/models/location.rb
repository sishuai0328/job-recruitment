class Location < ApplicationRecord

  validates :name, presence: { message: "请输入工作地点" }

  has_many :jobs
end
