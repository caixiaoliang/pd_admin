class Dealer < ActiveRecord::Base
  # attr_accessor :address_province_id

  has_many :orchestras
  has_many :pianos
  has_many :acoustics
  belongs_to :address_city,primary_key: "code"
  validates :name,presence: true
  validates_uniqueness_of :name

  def address_province_id
    self.address_city.try(:province).try(:code)
  end
end
