class Tag < ActiveRecord::Base
  has_many :models
  validates :name,presence: true
  validates_uniqueness_of :name
end
