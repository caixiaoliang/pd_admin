class Model < ActiveRecord::Base
  # 型号
  has_many :orchestras #音响
  has_many :pianos
  has_many :acoustics
  belongs_to :serial
  belongs_to :tag

  validates_uniqueness_of :name


  def model_cover
    "model_covers/#{self.cover}"
  end
end
