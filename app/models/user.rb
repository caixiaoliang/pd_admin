class User < ActiveRecord::Base

  validates :name,presence: true
  validates_uniqueness_of :name
  attr_accessor :account_type
  has_secure_password

  def authenticated?(token)
    digest = self.password_digest
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.now)
  end

  def admin?
    self.admin
  end
  
  def clear_remember_digest
      update_attribute(:remember_digest, nil)
  end

  class << self

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
       : BCrypt::Engine.cost
       BCrypt::Password.create(string,cost: cost) 
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def generate_password
      SecureRandom.hex(4)
    end

  end
end
