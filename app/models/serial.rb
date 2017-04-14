class Serial < ActiveRecord::Base
  # 系列
  has_many :models
  validates :name,presence: true
  validates_uniqueness_of :name
end